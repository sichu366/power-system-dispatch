function pre_X0 = wind_prediction(lambda, X, flag)
X0 = X;
k0 = 0;
break_fg = 0;
fg = 0;
%�����ۼ�����
n = length(X0);
m = length(lambda); %���ӵĸ���
X1 = zeros(1, n);
for i = 1:n
    if i == 1
        X1(1, i) = X0(1, i);
    else
        X1(1, i) = X1(1, i - 1) + X0(1, i);
    end
end

for k = 1:m
	%�������ݾ���Y�����ݾ���B
	Y = zeros(n - 1, 1);
	B = zeros(n - 1, 2);
	for i = 1:n - 1
		Y(i, 1) = X0(1, i + 1);
		B(i, 1) = -lambda(k, 1) * X1(1, i) - (1 - lambda(k, 1)) * X1(1, i + 1); 
		B(i, 2) = 1;
    end

	%����GM(1,1)ģ�͵ķ�չ����a����������ϵ��u
	A = zeros(2, 1);
	A = inv(B' * B) * B' * Y;
	a = A(1, 1);
	u = A(2, 1);
    %������ɫԤ��ģ��
	XX0 = zeros(1, n);
	XX0(1, 1) = X0(1, 1);
	for i = 2:n
		XX0(1, i) = (1 - exp(a)) * (X0(1, 1) - u / a) * exp(-a * (i - 1));
	end
	delta = X0 - XX0;
	%disp(delta);
	%�в�����
	for i = 1:(n)
		if delta(1, i) > 0
			for j = (i + 1):n
				if delta(1, j) < 0
					break_fg = 1;
					break;
				end
			end
			if ((j == n) & (break_fg == 0))
				k0 = i;
				fg = 1;
				break;
			end
		end
		if delta(1, i) < 0
			for j = (i + 1):n
				if delta(1, j) > 0
					break_fg = 1;
					break;
				end
			end
			if ((j == n) & (break_fg == 0))
				k0 = i;
				fg = -1;
				break;
			end
		end
		break_fg = 0;
	end
	if k0 ~= 0  %���k0��Ϊ0������Ҫ���вв�����
		disp(k0);
		%disp(fg);
		XX0(1, k0 + 1:n) = XX0(1, (k0 + 1):n) + 0.5 * fg * residual(delta(1, k0:n), 0);
	end
	if flag == 0
        pre_X0(k, :) = XX0;
	else if ((flag == 1) & (k0 ~= 0))
		pre_X0 = (1 - exp(a)) * (X0(1, 1) - u / a) * exp(-a * n) + 0.5 * fg * residual(delta(1, k0:n), 1);
	else
		pre_X0 = (1 - exp(a)) * (X0(1, 1) - u / a) * exp(-a * n);
	end
	fg = 0;
	k0 = 0;
	break_fg = 0; end
end
