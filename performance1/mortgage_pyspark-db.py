# Databricks notebook source
from sparkdl.xgboost import XgboostClassifier
from pyspark.ml.feature import VectorAssembler
from pyspark.sql.types import *

# COMMAND ----------

# when setting to false, => cpu loading + gpu training
# when seting to true (default) => gpu loading + gpu training
spark.conf.set("spark.rapids.sql.enabled", "false") 

# COMMAND ----------

df = spark.read.parquet(YOUR_MORTGAGE_DATA_PATH)
# print(df.count())

label = "delinquency_12"
features = [ item for item in df.schema.fieldNames() if item != label ]

features

# COMMAND ----------

vector_assembler = VectorAssembler()\
    .setInputCols(features)\
    .setOutputCol("features")

vector_df = vector_assembler.transform(df)\
  .withColumn('label', df[label].cast(FloatType()))\
  .select("features", 'label')

# COMMAND ----------

classifier = XgboostClassifier(num_workers=2, use_gpu=True, num_boost_round=100)
model = classifier.fit(vector_df)

# COMMAND ----------

classifier = XgboostClassifier(num_workers=2, use_gpu=True, num_boost_round=100)
model = classifier.fit(vector_df)

# COMMAND ----------

classifier = XgboostClassifier(num_workers=2, use_gpu=True, num_boost_round=100)
model = classifier.fit(vector_df)