% Task B - Förstner interest operator
function Foerstner(gradientX, gradientY,input_image)  
%part a and b
%first create a moving window 1 x 5
moving_window = ones(1, 5);  
% convolution of gradientX.^2 image with a moving_window (kernel) and
% ignore the boundaries ('same')

%source: a discussion on the Moodle forum to use conv2 twice:

gradientX_to_power_of_2 = gradientX.^2;
gradientY_to_power_of_2 = gradientY.^2;
gradientXY = gradientX.*gradientY;
%once with a row vector
convolutedByRowVector_Ix2 = conv2(gradientX_to_power_of_2,  moving_window, 'same');
convolutedByRowVector_Iy2 = conv2(gradientY_to_power_of_2,  moving_window, 'same');
convolutedByRowVector_IxIy = conv2(gradientXY, moving_window, 'same');

%once with a column vector
Ix2 = conv2(convolutedByRowVector_Ix2, moving_window', 'same'); 
Iy2 = conv2(convolutedByRowVector_Iy2, moving_window', 'same'); 
IxIy = conv2(convolutedByRowVector_IxIy, moving_window', 'same'); 

%page 31 of 05_iaor.pdf:    trace[a1 a2; a3 a4] = a1 + a4   <==>  trace[Ix2 IxIy; IxIy Iy2 ] 
traceA= Ix2 + Iy2; 
%page 31 of 05_iaor.pdf:    det[a1 a2; a3 a4] = a1a4  - a2a3   <==>  det[Ix2 IxIy; IxIy Iy2 ] 
detA= Ix2.*Iy2 -IxIy.^2;  
%page 38 of 05_iaor.pdf: improved cornerness (Shi & Tomasi)
Wklt = traceA/2 -(sqrt((traceA/2).^2 - detA));       
%page 38 of 05_iaor.pdf: Roundness (form factor):
q = 4*detA./(traceA.^2);    

figure, imshow(Wklt, []), title("Cornerness image",'Fontsize', 12);
figure, imshow(q, []), title("roundness image",'Fontsize', 12);

show_interest_points(Wklt,0.004,input_image);

end

function show_interest_points(Wklt,thresh,input_image)
%Maximum filter
%source: https://de.mathworks.com/help/images/ref/ordfilt2.html
filtered_cornerness = ordfilt2(Wklt, 9, ones(3,3));   

%create a new image
image_with_interest_points = ones();

%part C
% set the values of the image_with_interest_points 
for i = 1:length(Wklt(:,1))
    for j = 1:length(Wklt(1,:))
      % if the value equals the value in m and is larger than treshold 
        if Wklt(i,j) == filtered_cornerness(i,j) && Wklt(i,j) > thresh
           image_with_interest_points(i,j) = 1; 
        else 
            image_with_interest_points(i,j) = 0;
        end
    end
end 


%part D
figure;
imshow(input_image);
hold on;

% go into the image, if the value is not zero, save its row and column
% number, and draw it as a "*" on the input image
for i = 1:length(image_with_interest_points(:,1))
    for j = 1:length(image_with_interest_points(1,:))
       if image_with_interest_points(i,j) ~= 0 
           plot(j, i, 'b*');
  
       end
            
    end
        
end
title('image with detected points','Fontsize', 9);
end