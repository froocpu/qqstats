
fn_wca_average <- function(n, x, times){
  # Start at the end and work backwards.
  # take ID, get that row and the next 5 rows.
  # If you can't get the next 5 rows, return NA.
  # Else, remove the max and min and calculate the average.
  if(x < n) return(NA)
  min_array = x - (n-1)
  times_n = times[x:min_array]
  times_m = times_n[times_n < max(times_n) & times_n > min(times_n)]
  return(mean(times_m))
}

fn_moving_average <- function(times, n){
  new_times = sapply(length(times):1, function(i){
    return(fn_wca_average(n, i, times))
  })
  return(rev(new_times))
}

fn_convert_time <- function(t){
  if(grepl("[0-9]+:[0-9]{2}\\.[0-9]{2}", t)) return(period_to_seconds(ms(t)))
  if(grepl("[0-9]+:[0-9]{2}:[0-9]{2}\\.?([0-9]{2})?", t)) return(period_to_seconds(hms(t)))
  return(as.numeric(t))
}

fn_calculate_session_parts <- function(len){
  len4 = len/4
  if(len %% 4 == 0) return(rep(1:4, each=len4))
  len_ceil = ceiling(len4)
  if(len %% 2 == 0) {
    arr = c(rep(c(1,3), floor(len4)), rep(c(2,4), len_ceil))
    return(sort(arr))
  }
  if(len %% 4 == 1) return(c(1, rep(1:4, each=len4)))
  arr = rep(1:4, len_ceil)[-4]
  return(sort(arr))
}
