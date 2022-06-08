// Databricks notebook source
import ml.dmlc.xgboost4j.scala.spark.{XGBoostClassificationModel, XGBoostClassifier}

// COMMAND ----------

// when setting to false, => cpu loading + gpu training
// when seting to true (default) => gpu loading + gpu training
spark.conf.set("spark.rapids.sql.enabled", "true") 

// COMMAND ----------

val input = Seq(YOUR_MORTGAGE_DATA_PATH)
val rawInput = spark.read.parquet(input: _*)
// println(rawInput.count())

// COMMAND ----------

val labelColName = "delinquency_12"
val schema = rawInput.schema
val featureNames = schema.filter(_.name != labelColName).map(_.name).toArray

// COMMAND ----------

val xgbParamFinal = Map(
  "objective" -> "binary:logistic",
  "num_round" -> 100,
  "tree_method" -> "gpu_hist",
  "num_workers" -> 2,
  "nthread" -> 1,
)

val xgbClassifier = new XGBoostClassifier(xgbParamFinal)
  .setLabelCol(labelColName)
  .setFeaturesCol(featureNames)

// COMMAND ----------

val model1 = xgbClassifier.fit(rawInput)

// COMMAND ----------

val model2 = xgbClassifier.fit(rawInput)

// COMMAND ----------

val model3 = xgbClassifier.fit(rawInput)