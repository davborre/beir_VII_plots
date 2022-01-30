function linear_plotter(plotname,xdata,ydata,xtitle,ytitle,title)

g = gramm('x',xdata,'y',ydata);
g.set_title(title);
g.set_names('x',xtitle,'y',ytitle);

%g.stat_glm();
g.geom_point();

%g.set_color_options('map',[189/255,189/255,189/255]);
g.set_text_options( ...
    'font','Helvetica',...
    'interpreter','tex',...
    'base_size',18,...
    'label_scaling',1,...
    'legend_scaling',1,...
    'legend_title_scaling',1,...
    'facet_scaling',1,...
    'title_scaling',1,... 
    'big_title_scaling',1);

figure('Position',[100 100 450 450]);
g.draw();

g.export(...
    'file_name',plotname,...
    'file_type','png');

close all

end