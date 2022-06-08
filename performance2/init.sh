#!/bin/bash

# for 10.4
sudo rm -f /databricks/jars/spark--maven-trees--ml--10.x--xgboost-gpu--ml.dmlc--xgboost4j-gpu_2.12--ml.dmlc__xgboost4j-gpu_2.12__1.5.2.jar
sudo rm -f /databricks/jars/spark--maven-trees--ml--10.x--xgboost-gpu--ml.dmlc--xgboost4j-spark-gpu_2.12--ml.dmlc__xgboost4j-spark-gpu_2.12__1.5.2.jar

sudo wget -O /databricks/jars/xgboost4j-gpu_2.12-1.6.1.jar https://repo1.maven.org/maven2/ml/dmlc/xgboost4j-gpu_2.12/1.6.1/xgboost4j-gpu_2.12-1.6.1.jar
sudo wget -O /databricks/jars/xgboost4j-spark-gpu_2.12-1.6.1.jar https://repo1.maven.org/maven2/ml/dmlc/xgboost4j-spark-gpu_2.12/1.6.1/xgboost4j-spark-gpu_2.12-1.6.1.jar
sudo wget -O /databricks/jars/rapids-4-spark_2.12-22.04.0.jar https://repo1.maven.org/maven2/com/nvidia/rapids-4-spark_2.12/22.04.0/rapids-4-spark_2.12-22.04.0.jar
sudo wget -O /databricks/jars/cudf-22.04.0-cuda11.jar https://repo1.maven.org/maven2/ai/rapids/cudf/22.04.0/cudf-22.04.0-cuda11.jar
