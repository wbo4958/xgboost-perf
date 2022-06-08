# Performance test

This doc is demonstrating how to do the performance tests for xgboost. Before testing, you need to prepare the mortgage data.

## Mortgage dataset

1. Download the raw dataset from https://docs.rapids.ai/datasets/mortgage-data
2. Run the [ETL job](etl/mortgage_etl.scala) in Databricks envs.

## performance1 test

### create gpu instance

- Databricks Runtime Version
  
  `10.4 LTS ML (includes Apache Spark 3.2.1, GPU, Scala 2.12)`

- Worker Type
  
  2 * g4dn.2xlarge (32 GB Memory, 8 vCPUs, 1 GPU)

- Driver Type
  
  g4dn.xlarge (16 GB Memory, 4 vCPUs, 1 GPU)

- Spark configuration

    ``` console
    spark.task.resource.gpu.amount 1
    spark.task.cpus 8
    spark.rapids.memory.gpu.minAllocFraction 0.0001
    spark.plugins com.nvidia.spark.SQLPlugin
    spark.rapids.memory.gpu.pooling.enabled false
    spark.executor.resource.gpu.amount 1
    spark.rapids.memory.gpu.reserve 20
    spark.sql.adaptive.enabled false
    spark.rapids.sql.enabled false
    ```

- Init Script
  
    the init script can be found at [init.sh](performance1/init.sh)

Note that, Due to the limitation of `databricks-xgboost-pyspark`, we must set `spark.task.resource.gpu.amount 1`, which will cause
the issue that there are only 2 spark tasks running at a time, and it severely limits data-parallelism.

### benchmarking

Mortgage datasize: ((92, 954, 831) * 27)

|testing type|1st time(s)|2nd time(s)| 3rd time(s)|average(s)|
|----|----|----|----|----|
|`databricks-xgboost-pyspark 1.5.2`| 418.2 | 409.8| 396 | 408 |
|`cpu loading + gpu training on xgboost4j-gpu/xgboost4j-spark-gpu 1.6.1`| 456 | 436.2 | 439.2 | 443.8 |
|`gpu loading + gpu training on xgboost4j-gpu/xgboost4j-spark-gpu 1.6.1`| 96.6| 79.2 |  78.6 | 84.8 |
|`cpu loading + cpu training on xgboost4j-gpu/xgboost4j-spark-gpu 1.6.1`| 792 |  768 |  775.2| 778.4 |

### Question?

- Why choosing `databricks-xgboost-pyspark 1.5.2` based on xgboost python 1.5.2 release instead of xgboost python 1.6.1?

    This is the latest version that databricks xgboost pyspark supports, but there is not much difference on xgboost training between XGBoost 1.5.2 with 1.6.1

- Why choosing mortgage datasize to be (92, 954, 831)?

    That data size is the largest value that `databricks-xgboost-pyspark` can train, but xgboost4j can train twice than it.

## performance2

### create gpu instance

- Databricks Runtime Version
  
  `10.4 LTS ML (includes Apache Spark 3.2.1, GPU, Scala 2.12)`

- Worker Type
  
  2 * g4dn.2xlarge (32 GB Memory, 8 vCPUs, 1 GPU)

- Driver Type
  
  g4dn.xlarge (16 GB Memory, 4 vCPUs, 1 GPU)

- Spark configuration

    ``` console
    spark.task.resource.gpu.amount 0.125
    spark.task.cpus 1
    spark.rapids.memory.gpu.minAllocFraction 0.0001
    spark.plugins com.nvidia.spark.SQLPlugin
    spark.rapids.memory.gpu.pooling.enabled false
    spark.executor.resource.gpu.amount 1
    spark.rapids.memory.gpu.reserve 20
    spark.sql.adaptive.enabled false
    spark.rapids.sql.enabled false
    ```

- Init Script
  
    the init script can be found at [init.sh](performance2/init.sh)

With above configuration, we set the `spark.task.resource.gpu.amount=0.125`, why 0.125, (executor.gpu.amount/cpu cores)=1/8=0.125, which can allow 16 spark tasks running at a time.

### benchmarking

Mortgage datasize ((133, 831, 337) * 27)

|testing type|1st time(s)|2nd time(s)| 3rd time(s)|average(s)|
|----|----|----|----|----|
|cpu loading + cpu training on xgboost4j-gpu/xgboost4j-spark-gpu 1.6.1| 493.8 | 496.2 | 504| 498 |
|cpu loading + gpu training on xgboost4j-gpu/xgboost4j-spark-gpu 1.6.1| 399.6 | 391.2 | 391.2 | 394|
|gpu loading + gpu training on xgboost4j-gpu/xgboost4j-spark-gpu 1.6.1| 103.2| 92.4 | 90.6 | 95.4|
