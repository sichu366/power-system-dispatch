clear all;
clc;
load wind_power1
X0 = wind_outpower(81:96, 1)' / 10;  %����2017-11-26�ķ�������Ϊ��ʼֵ
X_real = wind_outpower(1:96, 2)' / 10;  %����2017-11-27�ķ�����
pre_X1 = zeros(1, length(X_real));
%��ʼ������
c1 = 2; %ѧϰ����1
c2 = 2; %ѧϰ����2
w = 0.7298; %����Ȩ��
MaxGeneration = 200; %����������
D = 1; %�����ռ�ά��lambda
N = 50; %��ʼ����Ⱥ������Ŀ
eps = 10 ^ (-6); %���þ���
x = zeros(N, D); %��ʼ������λ��
v = zeros(N, D); %��ʼ�������ٶ�
%��ʼ����Ⱥ����
for i = 1:N
	for j = 1:D
		x(i, j) = rand;
		v(i, j) = rand;
	end
end

for k = 1:length(X_real)
	%����������ӵ���Ӧ�ȣ�����ȫ������
	pre_X0 = wind_prediction(x, X0, 0);
	result = fitness(pre_X0, X0);
	pi = result;
	pg_value = zeros(1, length(X0));
	pg_value = result(1, :);
	pg = x(1, :);
	y = x;
	for i = 2:N
		if result(i) < pg_value
			pg = x(i, :);
			pg_value = result(i, :);
	    end
    end

    %������Ҫѭ�������չ�ʽһ�ε���
    for t = 1:MaxGeneration
	    for i = 1:N
		    v(i, :) = w * v(i, :) + c1 * rand * (y(i, :) - x(i, :)) + c2 * rand * (pg - x(i, :));
		    x(i, :) = x(i, :) + v(i, :);
		    if x(i, :) > 1
			    x(i, :) = 1
		    elseif x(i, :) < 0
			    x(i, :) = 0
		    end
	    end
	    pre_X0 = wind_prediction(x, X0, 0);
	    result = fitness(pre_X0, X0);
	    for i = 1:N
		    if result(i, :) < pi(i, :)
			    pi(i, :) = result(i, :);
			    y(i, :) = x(i, :);
		    end
		    if result(i, :) < pg_value
			    pg_value = result(i, :);
			    pg = x(i, :);
		    end
	    end
	    pre_X0 = wind_prediction(pg, X0, 0);
	    Pbest(t, :) = pre_X0;
    end
    pre_X1(1, k) = wind_prediction(pg, X0, 1);
    X0(1, 1:length(X0) - 1) = X0(1, 2:length(X0));
	X0(1, length(X0)) = X_real(1, k);
end


%ģ�;��ȼ���
%�в����
%n = length(X0);
%e = 0;
%for i =1:n
    %e = e + abs(X0(1, i) - Pbest(MaxGeneration, i)) / X0(1, i);
%end
%e = e / n;
%if e <= 0.01
    %disp('Ԥ��ģ��Ϊ��');
  %elseif e >= 0.01 && e <= 0.05
     %disp('Ԥ��ģ�ͺϸ�');
    %elseif e >= 0.05 && e <= 0.1
	   %disp('Ԥ��ģ����ǿ�ϸ�');
       %else
	      %disp('Ԥ��ģ�Ͳ��ϸ�');
%end

%��������
%����ԭʼ���б�׼��
%aver = 0; %ԭʼ����ƽ��ֵ
%for i = 1:n
	%aver = aver + X0(1, i);
%end
%aver = aver / n;

%S0 = 0; %ԭʼ���б�׼��
%for i = 1:n
	%S0 = S0 + (X0(1, i) - aver) ^ 2;
%end
%S0 = sqrt(S0 / (n - 1));

%Eaver = 0; %�������ƽ��ֵ
%for i = 1:n
	%Eaver = Eaver + X0(1, i) - Pbest(MaxGeneration, i);
%end
%Eaver = Eaver / n;

%Es0 = 0; %��������
%for i = 1:n
	%Es0 = Es0 + (X0(1, i) - Pbest(MaxGeneration, i) - Eaver) ^ 2;
%end
%Es0 = sqrt(Es0 / (n - 1));

%C = Es0 / S0; %���㷽���

%count = 0; %����С�������
%for i = 1:n
	%if abs(X0(1, i) - Pbest(MaxGeneration, i) - Eaver) < 0.6754 * S0
		%count = count + 1;
	%end
%end
%P = count / n;
%if P > 0.95 && C < 0.35
	%disp('Ԥ�⾫�Ⱥ�');
%elseif P > 0.8 && p < 0.95 && C > 0.35 && C < 0.5
	%disp('Ԥ�⾫�Ⱥϸ�');
%elseif P > 0.7 && P < 0.8 && C > 0.5 && C < 0.65
	%disp('Ԥ�⾫����ǿ�ϸ�');
%else
	%disp('���ϸ�');
%end



	

