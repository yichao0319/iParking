#!/bin/sh

rm NaiveBayes.ALL*.sh
rm NaiveBayes.FCBF*.sh
rm NaiveBayes.RANKER*.sh
rm NaiveBayes.BESTTFIRST*.sh
rm job.NaiveBayes.*.sh

./batch_eval_condor.sh 201504 NaiveBayes
./batch_eval_condor.sh 201505 NaiveBayes
./batch_eval_condor.sh 201506 NaiveBayes
./batch_eval_condor.sh 201507 NaiveBayes
./batch_eval_condor.sh 201508 NaiveBayes
./batch_eval_condor.sh 201509 NaiveBayes

