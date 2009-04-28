function [w,e] = lms(input, target, lr)
%function [w,e] = lms(input, target, lr)
%Trains a linear discriminator based on LMS training.
%Parameters:
%  - input : the input values
%  - target: the desired output
% - lr     : the learning rate value
%Returns the filter coeffitients w and the error e obtained in each iteraction.

[N, numEvents] = size(input);
w = zeros(1, N);
e = zeros(1,numEvents);

for i=1:numEvents,
  e(i) = target(i) - w*input(:,i);
  w = w + lr*input(:,i)'*e(i);
end