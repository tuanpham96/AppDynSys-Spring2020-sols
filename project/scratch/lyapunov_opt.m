function [Texp,Lexp]=lyapunov_opt(n,rhs_ext_fcn,fcn_integrator,tstart,stept,tend,ystart)

n1=n; n2=n1*(n1+1);

R_1toN = 1:n1; 

nit = round((tend-tstart)/stept);

y=zeros(n2,1); cum=zeros(n1,1); y0=y;
gsc=cum; znorm=cum;

y(1:n)=ystart(:);

y((n1+1)*R_1toN)=1.0;

t=tstart;
Lexp = zeros(nit, n1); 
Texp = zeros(nit, 1);
for ITERLYAP=1:nit
    
    [~,Y] = feval(fcn_integrator,rhs_ext_fcn,[t t+stept],y);
    
    t=t+stept;
    y=Y(size(Y,1),:);
    
    for i=1:n1
        y0(n1*i+R_1toN)=y(n1*R_1toN+i);
    end
   
    znorm(1)=sqrt(sum(y0(n1*R_1toN+1).^2));
    
    y0(n1*R_1toN+1)=y0(n1*R_1toN+1)/znorm(1);
    
    for j=2:n1
        for k=1:(j-1)
            gsc(k)= sum(y0(n1*R_1toN+j).*y0(n1*R_1toN+k));
        end
        
        for k=1:n1
            y0(n1*k+j)=y0(n1*k+j)-sum(gsc(1:(j-1)).*y0(n1*k+(1:(j-1))));
        end
        znorm(j)=sqrt(sum(y0(n1*R_1toN+j).^2));
        y0(n1*R_1toN+j)=y0(n1*R_1toN+j)/znorm(j);
    end
    
    cum=cumsum(log(znorm));
    
    lp = cum/(t-tstart);
    Lexp(ITERLYAP,:)=lp;
    Texp(ITERLYAP,:)=t;

    
    for i=1:n1
        y(n1*R_1toN+i)=y0(n1*i+R_1toN);
        
    end
    
end