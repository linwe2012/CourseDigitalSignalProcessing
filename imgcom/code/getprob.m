function [sym, prob] = getprob(A)
A_size = size(A);
% sym = 1:(-128):127;
sym = [];
prob = [];

for i=1:A_size(2)
    pos = find(sym == A(i));
    if isempty(pos)
        prob = [prob, 1];
        sym = [sym, A(i)];
    else
        prob(pos) = prob(pos) + 1;
    end   
end
prob = prob ./ A_size(2);
end

