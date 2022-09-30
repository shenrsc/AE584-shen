figure(1)
length(0:0.05:10)
semilogy(0:0.5:10,far,'g','linewidth',1);
xlim([0,10]);
xticks(0:2:10);
xlabel('value of snesor error');
ylabel('logarithmic position degrades');
grid on;