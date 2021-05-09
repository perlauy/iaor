function main
  I = imread('ampelmaennchen.png');
  
  IReady = preprocess(I);
    
  GoG(IReady, .5);
end

### Preprocess an RGB image to work with
function [output] = preprocess(img)
  gray = rgb2gray(img);
  output = im2double (gray);

  # Uncomment to visualize result:
  # figure, imshow(output), title("preprocess");
end
