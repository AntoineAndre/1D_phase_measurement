function error = angdiff(alpha, beta)
% delta = angdiff(alpha,beta) calculates the difference between the angles 
% alpha and beta. This function subtracts alpha from beta with the result 
% wrapped on the interval [-pi,pi]. You can specify the input angles as 
% single values or as arrays of angles that have the same number of values.

difference = alpha - beta; 
error = mod(difference+pi, 2*pi) - pi;
