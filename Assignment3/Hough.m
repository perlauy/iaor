function [voting_array, rho, theta] = Hough(mask, gradient_x, gradient_y)
  
  % Initialize discreet accumulator H(0…180, -d…d) for d= sqrt(w²+h²)to all zeros
  [w, h] = size(mask);
  d = ceil(sqrt(w ^ 2 + h ^ 2));
  voting_array = zeros(d * 2 + 1, 180);
  
  % foreach edge point (x, y) in the imagefor?= 0 to 180?= xcos ?+ ysin ?H(?, ?) = H(?, ?) + 1endend  
  
  % Initialize index vectors
  rho = -d:d;
  theta = -90:89;
  % We get [-90,-89,-88...] and using find(), we can get a map to indexes 1-180
 
  % Create two arrays, with only the positions of the relevant points
  % (no need to work on the points outside it)
  [y, x] = find(mask > 0);
    
  for i = 1:length(x)
  
      % Non-optimized solution:
      %for angle = -90:89  
       % ro = x * cos(angle) + y * sin(angle);        
        %++voting_array(angle, round(ro));
      %end
      
    % For faster algorithm, use gradient
    gradient_angle = rad2deg(atan2(gradient_y(y(i), x(i)), gradient_x(y(i), x(i))));
    angle = round(gradient_angle);
    
    distance = round(x(i) * cos(deg2rad(angle)) + y(i) * sin(deg2rad(angle)));
    
    % find the correct indexes, mapping with reference arrays
    rho_i = find(rho == distance);
    theta_i = find(theta == angle);
    
    ++voting_array(rho_i, theta_i);
  end
  
  
end