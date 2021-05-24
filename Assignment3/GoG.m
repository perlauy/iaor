% Task A - Gradient of Gaussian

function [gradientX, gradientY, magnitude] = GoG(img, deviation)

  % A) a -> Kernels
  [xKernel, yKernel] = GoGKernels(deviation);
 
  % A) b -> Apply filter
  [gradientX, gradientY] = GoGGradients(img, xKernel, yKernel);
  
  % A) c -> Gradient magnitude
  magnitude = gradientMagnitude(gradientX, gradientY);
  

end


function [xKernel, yKernel] = GoGKernels(deviation)
  radius = ceil(deviation * 3);
  size = radius * 2 + 1;
  xArray = zeros(size,size);
  for i = 1:size
    xArray(:, i) = i - (radius + 1);
  end
 
  yArray = xArray';
  
  xBase = -xArray / ( 2 * pi * power(deviation, 4));
  exponent = -(xArray .^ 2 + yArray .^ 2) / (2 * deviation * deviation);
  
  xKernel = xBase .* exp(exponent);
  yKernel = xKernel';
 
end


function [gradientX, gradientY] = GoGGradients(img, xKernel, yKernel)
  gradientX = conv2(img, xKernel);
  gradientY = conv2(img, yKernel);
 
  % figure, imshow(img), title("Original");
  % figure, imshow(gradientX, []), title("Gradient X");
  % figure, imshow(gradientY, []), title("Gradient Y");
end


function [output] = gradientMagnitude(gx, gy)
  output = sqrt(gx .^ 2 + gy .^ 2);

  % figure, imshow(output, []), title("Gradient Magnitude");
 end 
  