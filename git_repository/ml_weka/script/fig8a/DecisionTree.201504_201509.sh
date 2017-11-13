#!/bin/sh

rm NaiveBayes.ALL*.sh
rm NaiveBayes.FCBF*.sh
rm NaiveBayes.RANKER*.sh
rm NaiveBayes.BESTTFIRST*.sh
rm job.NaiveBayes.*.sh

./batch_eval_condor.sh 201504 C45
./batch_eval_condor.sh 201505 C45
./batch_eval_condor.sh 201506 C45
./batch_eval_condor.sh 201507 C45
./batch_eval_condor.sh 201508 C45
./batch_eval_condor.sh 201509 C45

