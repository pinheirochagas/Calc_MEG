function topoplot_wrapper_fieldtrip(vec)
    cfg=[];
    cfg.layout = 'neuromag306mag.lay'; % whatever your layout file is
    topoplot(cfg,vec);
    return
end