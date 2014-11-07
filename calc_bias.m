function bias = calc_bias(buoy,model)

bias = mean(model - buoy);