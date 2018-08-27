function [V_RF, V_U] = Wgevd_algorithm(V_RF, w, H1, O)

global Ns  Nrf Vn;
Nt = size(V_RF,1);
theta = 1/(Vn * w * Nt);  % for simplification

for m = 1: 2  %outer iteration
    for j = 1: Nrf
        V_m = V_RF;
        V_m(:,j) = [];
        Am = O^(-1) + theta * H1' * V_m * V_m' * H1;
        Um = theta * H1 * Am^(-2) * H1';
        Wm = 1/Nt * eye(Nt) + theta * H1 * Am^(-1) * H1';
        [V,D] = eig(Um, Wm);
        % get the largest eigenvector
        [~,max_index] = max(diag(D));
        V_RF(:,j) = exp(1i * angle(V(:,max_index)));
    end
end

V_U = inv(V_RF'*H1 *O* H1'* V_RF+  Vn *  w *(V_RF)'*V_RF)*V_RF'*H1 * O;
