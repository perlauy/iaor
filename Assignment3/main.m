function main
  
  figure;
  
  % a) Read and prepare image
  I = imread('input_ex3.jpg');
  I_ready = preprocess(I);  

  % b) Apply GoG filter
  [gradient_x, gradient_y, magnitude] = GoG(I_ready, .5);
  
  % c) Try and find meaningful threshold
  IMG_THRESHOLD = .08;
  binary_edge_mask = magnitude > IMG_THRESHOLD;
  
  subplot(1, 4, 2);
  imshow(binary_edge_mask, []), title("Binary edge mask");
  
  % d) Implement Hough
  [hough_votes, rho, theta] = Hough(binary_edge_mask, gradient_x, gradient_y);
  
  % e) Plot
  subplot(1, 4, 3);
  
  % XData and YData give the limits of the values, to be plotted correctly.
  imshow (hough_votes, 'XData',theta,'YData',rho), title ("Hough voting space");
  axis on, axis normal; xlabel("theta [degrees]"); ylabel("rho [pixels]");
  
  % f) Local maxima
  % https://octave.sourceforge.io/image/function/houghpeaks.html
  peaks = houghpeaks(hough_votes, 50, 'threshold', 5);
  peaks_rho = rho(peaks(:,1));
  peaks_theta = theta(peaks(:,2));

  % g) Plot the points
  hold on;
  plot(peaks_theta,peaks_rho,'s','color','red');
  hold off;
  
  % h) Derive line segments
  % https://octave.sourceforge.io/image/function/houghlines.html
  lines = houghlines(binary_edge_mask, theta, rho, peaks, 'FillGap', 5, 'MinLength', 7);

  % i) Plot on figure
  subplot(1, 4, 4);
  imshow(I_ready), title ("Lines");
  hold on;

  % lines is struct array: point1, point2, theta, rho
  for i = 1:length(lines)
     points = [lines(i).point1; lines(i).point2];
     plot(points(:,1), points(:,2), 'LineWidth', 2, 'g');

     % Plot beginnings and ends of lines
     plot(points(1,1), points(1,2), 'x', 'LineWidth', 1, 'Color', 'yellow');
     plot(points(2,1), points(2,2), 'x', 'LineWidth', 1, 'Color', 'red');

  end 
  
  hold off;
end

% Preprocess an RGB image to work with
function [output] = preprocess(img)
  gray = rgb2gray(img);
  output = im2double(gray);

  subplot(1, 4, 1);
  imshow(output), title("Preprocess");
end
