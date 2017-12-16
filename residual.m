function delta = residual(X, flg)
X0 = X;
%disp(X0);
%�����ۼ�����
n = length(X0);
X1 = zeros(1, n);
for i = 1:n
    if i == 1
        X1(1, i) = X0(1, i);
    else
        X1(1, i) = X1(1, i - 1) + X0(1, i);
    end
end

%�������ݾ���Y�����ݾ���B
Y = zeros(n - 1, 1);
B = zeros(n - 1, 2);
for i = 1:n - 1
	Y(i, 1) = X0(1, i + 1);
	B(i, 1) = -0.5 * X1(1, i) - 0.5 * X1(1, i + 1); 
	B(i, 2) = 1;
end

%����GM(1,1)ģ�͵ķ�չ����a����������ϵ��u
A = zeros(2, 1);
%disp(B);
%disp(Y);
A = pinv(B) * Y;
a = A(1, 1);
u = A(2, 1);
%disp(A);
if flg == 0
    for i = 2:n
        delta(1, i - 1) = (-a) * (X0(1, 1) - u / a) * exp(-a * (i - 1));
		disp(delta);
    end
else
    delta = (-a) * (X0(1, 1) - u / a) * exp(-a * n);
end
end

