function cost = wwMMSE_cost(x,H,Vn,O)

global Nrf  Ns Nk;
Nr = size(H,1);

x = reshape(x,Nr,Nrf);

for i = 1:Nk
    cost(i) = trace(O(:,:,i)*(H(:,:,i)'*x*(x'*x)^(-1)*x'*H(:,:,i)/Vn(i)+eye(Ns))^(-1));
end
cost = sum(cost);