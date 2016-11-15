v=0:0.05:1.6;
%Os(Os==Inf)=0;
p=plot(v,Os(:,1),v,OS(:,1));
set(p(1),'linewidth',2);
set(p(2),'linewidth',2);
xlabel('Holding Cost');
ylabel('(s,S)');
legend('s','S');
 title('Linear Cost');

q=OS;
h=Os;
v=0:0.05:1.6;
v=0:0.4:4;
pic=figure;
p=plot(v,Os(:,1),'--r',v,OS(:,1),'r',v,h(:,1),'--b',v,q(:,1),'b');
set(p(1),'linewidth',2);
set(p(2),'linewidth',2);
set(p(3),'linewidth',2);
set(p(4),'linewidth',2);
xlabel('Holding Cost');
ylabel('(s,S)');
legend('RN-s','RN-S','RS-s','RS-S');
title('Risk Sensitive (RS) vs Risk Neutral (RN)');

print(pic,'-djpeg','-r300','RS0.2vsRN');