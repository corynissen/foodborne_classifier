# foodborne_classifier

The classifier used in the http://foodborne.smartchicagoapps.org/ application.

## Prediction
The prediction is done via a webservice running on an EC2 instance running ubuntu, R, apache, and the [FastRWeb package](http://www.rforge.net/FastRWeb/) to pull it all together.

### How it's Served
The FastRWeb package takes a .R file (fp_classifier.R in my case) with a "run" function and makes it available via the web. I use this to submit text and return a classification... <http://174.129.49.183/cgi-bin/R/fp_classifier?text=I%20ate%20some%20bad%20food%20at%20lunch%20and%20think%20I%20have%20food%20poisoning>

### Classifier Code
I've tried several packages. [RTextTools] (http://cran.r-project.org/web/packages/RTextTools/index.html) is a great resource, but a very simple n-gram based system [TextCat] (http://cran.r-project.org/web/packages/textcat/index.html) is sufficient for this project. It reads in a pre-trained model file on startup, and calculates a predicted classification based on the text input from the user.

## Model Training
First, I download the data from our mongodb where it's stored. Then I manually classify the data to train the model. Then save the trained model to a file for use on the server.

### Get the Data
First, I download the tweets from mongodb using [RMongo] (http://cran.r-project.org/web/packages/RMongo/index.html) package. Save these tweets to a csv file for the manual classification step.

### Manually Classify
I couldn't concentrate well staring at a wall of text, so I found a nugget of code online that allowed me to run a script from the command line and input a single character and not have to hit enter. Basically, I can just keep my fingers on 1 and 0 and rapid fire the manual part of this.

### Train Model
The first part is to pre-process the data before training the model. In this case, I take out special characters and punctuation. I also replace all links with "urlextracted". The idea behind this is that nearly all tweets with links in them are "junk", that is, news articles about food poisoning, not specific instances of an illness. So, by treating all of those links the same, the model should associate "urlextracted" with junk fairly well. Then save the trained model as a file.

## R Packages
[textcat] (http://cran.r-project.org/web/packages/textcat/index.html)
[stringr] (http://cran.r-project.org/web/packages/stringr/index.html)
[RMongo] (http://cran.r-project.org/web/packages/RMongo/index.html)
[FastRWeb] (http://www.rforge.net/FastRWeb/)

## Copyright

Copyright (c) 2013 Cory Nissen. Released under the MIT License.
