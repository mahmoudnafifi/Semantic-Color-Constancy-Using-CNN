function plotTrainingAccuracy(info)

persistent plotObj

if info.State == "start"
    plotObj = animatedline;
    xlabel("Iteration")
    ylabel("RMSE")
elseif info.State == "iteration"
    addpoints(plotObj,info.Iteration,double((info.TrainingRMSE)))
    drawnow limitrate nocallbacks
end

end