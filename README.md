<h1>The stochastic model of agonistic interactions  </h1>

<p> This is an individual-based simulation model, in which we establish scenarios combining different levels of correlation between attributes and their relative importance in determining Fighting Capacity. This model was used to investigate emerging patterns of differences between winners and losers for each attribute involved in the fight.</p>
<p>The correlated atributes used to exemplify the system were body size and weapon size</p>

<h2>Setting up the environment</h2>

<p>These packages were used:</p>

<ul>
  <li>faux</li>
  <li>dplyr</li>
  <li>tidyverse</li>
  <li>boot</li>
  <li>sciplot</li>
  <li>ggplot2</li>
  <li>ggthemes</li>
  <li>devtools</li>
</ul>

<h2> Main function </h2>

<p>"simulation" is the main function. </p>
<p>Its parameters are:</p>

<ul>
  <li> "cor.weapon.body", the value of correlation between traits weapon and body</li>
  <li> "weapon.imp", the relative importance of the weapon size trait for the chance of winning a contest</li>
  <li>"body.imp" is the relative importance of the body size trait for the chance of winning a contest and, since it is a consequential value of "weapon.imp", it is calculated inside the function</li>
</ul>

<h3>Inside the function </h3>

<p>the following empty vectors will store corresponding data:</p>

<ul>
  <li>"mean.body.win": the mean of the body size values of the individuals that won.</li>
  <li>"mean.body.los": the mean of the body size values of the individuals that lost.</li>
  <li>"mean.weap.win": the mean of the weapon size values of the individuals that won.</li>
  <li>"mean.weap.los": the mean of the weapon size values of the individuals that lost.</li>
  <li>"body.diff": the difference between the mean of the body size values of the individuals that won and the mean of the body size values of the individuals that lost.</li>
  <li>"weap.diff": the difference between the mean of the weapon size values of the individuals that won and the mean of the weapon size values of the individuals that lost.</li>
  </ul>


<h2>Creating Individuals</h2>

  <p>"group.1" and "group.2" are objects that will store two sets of data. The "rnorm_multi" function allows us to create two sets of normal distributions and correlate them</p>
  <p>The correlation value will be the one stipulated outside the function </p>
  <p>One on the sets of normal distributions will represent body size, and the other, weapon size</p>
  <p>data.1 is the data frame where the information in the function will be stored</p>
  <p>We input “group.1” and “group.2” into the data frame so that the body and weapon of each individual is stored in a separate column</p>

<h2>Simulate fight</h2>

<h3>Each line on the data frame “data.1” is representative of a fight, containing the fighting pair</h3>

<ul>
<li> “data.1$FC.1” and  “data.1$FC.2” are new columns in the data frame that will store the Fighting Capacity value of each individual from “group.1” and “group.2” respectively</li>
<li>”data.1$FCdiff” is a new column in the data frame that will store the value of Fighting Capacity of the individual from "group.1" minus the one from “group.2” </li>
<li>”data.1$prob.win.cont” is a new column in the data frame that will store a probability value from zero to one of the individual from “group.1” from each line to win</li>
</ul>

<h2>Determine winner</h2>

<p>”data.1$prob.win” is a new column in the data frame that will store a value “1” or “0” depending on the probability from the previous column.</p>
<p>Value “1” represents that the individual from “group.1” has one and value “0” represents that it has not won, and by conclusion, the individual from “group.2” has won</p>

<h3>Store data about winners and losers</h3>

<ul>
 
  <li> “data.1$win.body” stores the value of body size for the winning individual</li>
  <p>This will be filled with the body size from the individual from “group.1” if “data.1$prob.win” is marked “1”. If not, it will be filled with the body size from the individual from “group.2”</p>
  <li>”data.1$los.body” stores the value of body size for the losing individual</li>
  <p>This will be filled with the body size from the individual from “group.2” if the previous column is storing data from “group.1”. If not, it will be filled with data from “group.1”</p>
 
  <li>”data.1$win.weap” stores the value of weapon size for the winning individual</li>
  <p>This will be filled with the weapon size from the individual from “group.1” if “data.1$prob.win” is marked “1”. If not, it will be filled with the weapon size from the individual from “group.2”</p>
  <li>”data.1$los.weap” stores the value of weapon size for the losing individual</li>
  <p>This will be filled with the weapon size from the individual from “group.2” if the previous column is storing data from “group.1”. If not, it will be filled with data from “group.1”</p>

</ul>

 <h3>Determine differences between winners and losers</h3>

<p>”data.1$diff.body” is a new column in the data frame that will store the difference between the winning body value and the losing body value </p>
<p> “data.1$diff.weap” in a new column in the data frame that will store the difference between the winning weapon and the losing weapon value </p>

<h3>Means</h3>

<p>The means from each iteration of the for loop will be stored in the following lists:</p>

<ul>
   <li> “mean.body.win[m]” stores the mean of the body size from winning individuals</li>
   <li>”mean.body.los[m]” stores the mean of the body size from losing individuals</li>
   <li>”mean.weap.win[m]” stores the mean of the weapon size from winning individuals</li>
   <li>”mean.weap.los[m]” stores the mean of the weapon size from losing individuals</li>
   <li>”body.diff[m]” stores the mean of the difference of body size between winners and losers</li>
   <li>”weap.diff[m]” stores the mean of the difference of weapon size between winners and losers</li>
</ul>

<h3>The for loop ends here</h3>

 <h2>Means and Confidence Intervals</h2>
 
 <p>”mean.mean.body” stores the mean of every iteration of mean of difference between winners and losers in body size</p>
 <p>”mean.mean.weap” stores the mean of every iteration of mean of difference between winners and losers in weapon size</p>
 <p>”body.mean.CI “stores the confidence interval for body size difference</p>
 <p>”weap.mean.CI” stores the confidence interval for weapon size difference</p>
 <p>”data.2” is the return of the simulation function. It lists “mean.mean.body”, “mean.mean.weap”, “body.mean.CI” and “weap.mean.CI”.</p>

 <h3>The simulation function end here</h3>
  
 <h2>Applying the simulation function</h2>

<p>func.values is an empty vector for the loop. It stores the output values of the simulation</p>
<p>We set “i” in 80 to 99. “i” will be divided by one hundred and perform as the correlation values. In this way, correlation will be the 20 values from 0.80 to 0.99 going 0.01 by 0.01</p>
<p>As we append the values in “func.values”, we have the chance to modify the weapon importance parameter. Here we left it set as 0.5</p>

 <h2>Organize data for figure</h2>
 
 <p>treatments is a list that repeats the labels “mean.mean.body”, “mean.mean.weap”, “body.mean.CI” and “weap.mean.CI”</p>
 <p>Here we set it to repeat each label 20 times because we have 20 inputs (from 0.80 to 0.99) and so will have 20 outputs</p>
 <p>correlations will label the correlation values to “mean.mean.body”, “mean.mean.weap”, “body.mean.CI” and “weap.mean.CI”</p>
 <p>”data.mix” is a new data frame created to structure the data for the figure</p>
 <p>It unites the labels with the outputted values correspondently</p>
 <p>”data.fig” is a similar data frame. However, we took the confidence intervals out of treatments and into its own column for purposes of making the figure. </p>

  

