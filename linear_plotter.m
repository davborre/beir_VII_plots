function linear_plotter(plotname,xdata,ydata,group,xtitle,ytitle,title,...
    ylim,ytick,leg_pos,ytickformat,yminortick)

g = gramm('x',xdata,'y',ydata,'color',group,'linestyle',group);
g.set_title(title);
g.set_names('x',xtitle,'y',ytitle,'color','','linestyle','');

g.geom_line();

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

g.set_layout_options( ...
    'legend_position',leg_pos);

line_colors = [0 0 0; .5 .5 .5; .8 .8 .8]; %fractional value; RGB color model
g.set_color_options('map',line_colors,'legend','merge')

g.axe_property( ...
    'YLim',ylim,...
    'YTick',ytick,...
    'YMinorTick','on',...
    'XLim',[25 90],...
    'XTick',30:10:90,...
    'XMinorTick','on');

figure('Position',[100 100 650 450]);
g.draw();

%{
minor tweaks that:
 #1 - pass formatting operator for how numbers on axes are to be displayed
 #2 - increase weight of lines used in drawing axes
 #3 - specify values at which minor tick marks are drawn
 #4 - nudge axis title position to add white space between title and numbers  
%}
arrayfun(@(s)set(s.YAxis,'TickLabelFormat',ytickformat),g.facet_axes_handles) % #1
arrayfun(@(s)set(s.XAxis,'LineWidth',2),g.facet_axes_handles)                 % #2
arrayfun(@(s)set(s.YAxis,'LineWidth',2),g.facet_axes_handles)                 
arrayfun(@(s)set(s.XAxis,'MinorTickValues',35:10:95),g.facet_axes_handles)    % #3
arrayfun(@(s)set(s.YAxis,'MinorTickValues',yminortick),g.facet_axes_handles)  
ylabel_pos = g.facet_axes_handles.YLabel.Position;                            
ylabel_pos(1) = ylabel_pos(1)-1;
arrayfun(@(s)set(s.YLabel,'Position',ylabel_pos),g.facet_axes_handles);       % #4


extensions = {'svg','png','eps','pdf'};

for i=1:length(extensions)
    g.export(...
        'file_name',plotname,...
        'file_type',extensions{i});
end

close all

end