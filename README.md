# qqstats

## What is this?

The initial commit for an R project for visualising and analysing qqtimer.net sessions. It will contain:

- Some analysis functions in a directory called `functions/`.
- An `example/` directory containing some sample data.
- A single R script called `calculate.R`, which should be run as follows in full in RStudio for the best results.

## What does it do?

- Calculate the Ao5, Ao12 and Ao25 moving averages for you.
- Transforms the solve times for easier use. For example, 24.14s -> **24**.
- Saves the data for you in your chosen directory.
- Visualises the data. Example below:

![Example plot](examples/moving_average_example.png)

## How to use it

After cloning the project:

1. Open the project file in RStudio.
2. If necessary, install the necessary libraries:

```r
install.packages(c("lubridate", "ggplot2", "scales", "reshape2"))
```

3. Set your inputs: 
  a. the name of the event 
  b. the TRUE/FALSE flag indicating whether you would like your results saved.
  c. the directory to where your results should be saved.
4. Select the whole script and run everything in one go.

## Contribute

If there are any issues, please feel free to message me and leave issues. If you would like to make some changes, please create a separate branch and then create a merge request with the changes you would like to make.

## Enjoy!

If you liked the script, buy me a tea with some [lumens](https://www.stellar.org/):

GDGR5JMOB74XEYVKTBNZWJRNE4AGEMEHDIPEV2CI62P34VP33EQ3X7BJ
