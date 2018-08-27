function [obj] = OMP_wbmethod(obj)

global H W_mopt Nk Nt Nr  Ns Vn Codebook_v Codebook_w;
t1 = clock;
n = 0;
w = zeros(Nk,1);
v = zeros(Nk,1);
%init
W_equal = W_mopt;
V_equal = zeros(Nt,Ns,Nk);
H_equal = zeros(Ns,Ns,Nk);
m_mse = zeros(Nk,1);

for i = 1:Nk
    w(i) = trace(W_equal(:,:,i)'*W_equal(:,:,i));
end

H1 = zeros(Nt,Ns,Nk);
H2 = zeros(Nr,Ns,Nk);
trigger = 1;
m_MSE_new = 100;


while (trigger > 1e-3 && n<10)
    
    Vn1 = Vn * w;
    for i = 1: Nk
        H1(:,:,i) = H(:,:,i)'*W_equal(:,:,i);
    end
    [V_RF,V_U] = OMP_alg(H1,Codebook_v,Vn1);
    
    for i = 1:Nk
        V_equal(:,:,i) = V_RF * V_U(:,:,i);
        v(i) = trace(V_equal(:,:,i)'*V_equal(:,:,i));
        H2(:,:,i) = H(:,:,i)*V_equal(:,:,i);
    end
    Vn2 = Vn * v;
    [W_RF,W_B] = OMP_alg(H2,Codebook_w,Vn2);
    
    m_MSE_old = m_MSE_new;
    
    for k = 1:Nk
        W_equal(:,:,k) = W_RF * W_B(:,:,k);
        w(i) = trace(W_equal(:,:,i)'*W_equal(:,:,i));
        H_equal(:,:,k) = W_equal(:,:,k)'*H2(:,:,k);
        m_mse(k) = trace(H_equal(:,:,k) * H_equal(:,:,k)' - H_equal(:,:,k) - H_equal(:,:,k)')...
            + Vn * v(k) * w(k);
    end
    m_MSE_new = sum(m_mse)/Nk;
    trigger = m_MSE_old - m_MSE_new;
    n = n + 1;
end

for i = 1:Nk
    V_B(:,:,i)= V_U(:,:,i) /sqrt(v(i));
end

t2 = clock;
runtime  = etime(t2,t1);
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj.runtime = obj.runtime + runtime;
obj.iter = obj.iter + n;
obj = get_wbmetric(obj);