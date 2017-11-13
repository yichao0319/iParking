#!/bin/sh

rm NaiveBayes.ALL*.sh
rm NaiveBayes.FCBF*.sh
rm NaiveBayes.RANKER*.sh
rm NaiveBayes.BESTTFIRST*.sh
rm job.NaiveBayes.*.sh

./batch_eval_condor.sh 201510 NaiveBayes
./batch_eval_condor.sh 201511 NaiveBayes
./batch_eval_condor.sh 201512 NaiveBayes
./batch_eval_condor.sh 201601 NaiveBayes
./batch_eval_condor.sh 201602 NaiveBayes
./batch_eval_condor.sh 201603 NaiveBayes

