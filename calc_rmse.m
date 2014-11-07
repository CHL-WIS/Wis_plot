function rmse = calc_rmse(buoy,model)

bias = mean(model - buoy);
len = length(buoy);
rmse = sqrt(sum((model - buoy - bias).^2)/len);
end