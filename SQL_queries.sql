--Creating stage table
CREATE TABLE `comp_4449_final`.`stagenewproductdiscription` (
  `ProdID` INT NULL,
  `ProductDiscritonID` TEXT(10000) NULL,
  `Clean_body_text` TEXT(10000) NULL,
  `model_info` TEXT(10000) NULL,
  `draft_text` TEXT(10000) NULL,
  `model_id` TEXT(10000) NULL,
  `model_object` TEXT(10000) NULL,
  `model_created` BIGINT NULL,
  `model_type` TEXT(10000) NULL,
  `choices_text` TEXT(10000) NULL,
  `choices_index` INT NULL,
  `choices_logprobs` INT NULL,
  `choices_finish_reason` TEXT(10000) NULL,
  `usage_prompt_tokens` BIGINT NULL,
  `usage_completion_tokens` BIGINT NULL,
  `usage_total_tokens` BIGINT NULL,
  `grammar_Object` TEXT(10000) NULL,
  `crammar_created` BIGINT NULL,
  `grammat_fixed_text` TEXT(10000) NULL,
  `grammar_prompt_tokens` BIGINT NULL,
  `grammar_completion_tokens` BIGINT NULL,
  `grammar_total_tokens` BIGINT NULL,
  `flesch_reading_ease` FLOAT NULL,
  `flesch_kincaid_grade` FLOAT NULL,
  `product_discription_value` FLOAT NULL);
  
-- creating live table for new product discriptions
  CREATE TABLE `comp_4449_final`.`newproductdiscription` (
  `ProdID` INT NULL,
  `ProductDiscritonID` TEXT(10000) NULL,
  `Clean_body_text` TEXT(10000) NULL,
  `model_info` TEXT(10000) NULL,
  `draft_text` TEXT(10000) NULL,
  `model_id` TEXT(10000) NULL,
  `model_object` TEXT(10000) NULL,
  `model_created` BIGINT NULL,
  `model_type` TEXT(10000) NULL,
  `choices_text` TEXT(10000) NULL,
  `choices_index` INT NULL,
  `choices_logprobs` INT NULL,
  `choices_finish_reason` TEXT(10000) NULL,
  `usage_prompt_tokens` BIGINT NULL,
  `usage_completion_tokens` BIGINT NULL,
  `usage_total_tokens` BIGINT NULL,
  `grammar_Object` TEXT(10000) NULL,
  `crammar_created` BIGINT NULL,
  `grammat_fixed_text` TEXT(10000) NULL,
  `grammar_prompt_tokens` BIGINT NULL,
  `grammar_completion_tokens` BIGINT NULL,
  `grammar_total_tokens` BIGINT NULL,
  `flesch_reading_ease` FLOAT NULL,
  `flesch_kincaid_grade` FLOAT NULL,
  `product_discription_value` FLOAT NULL);


  --SQL for inserting new records form stage into live table
INSERT INTO comp_4449_final.newproductdiscription
SELECT tb1.prodID,
(SELECT max(ProductDiscritonID) FROM comp_4449_final.newproductdiscription)+1,
tb1.Clean_body_text,
	tb1.model_info	,
    tb1.draft_text	,
    tb1.model_id	,
    tb1.model_object,	
    tb1.model_created,	
    tb1.model_type	,
    tb1.choices_text,	
    tb1.choices_index,	
    tb1.choices_logprobs,	
    tb1.choices_finish_reason,	
    tb1.usage_prompt_tokens	,
    tb1.usage_completion_tokens,	
    tb1.usage_total_tokens	,
    tb1.grammar_Object	,
    tb1.crammar_created	,
    tb1.grammat_fixed_text,	
    tb1.grammar_prompt_tokens,	
    tb1.grammar_completion_tokens,	
    tb1.grammar_total_tokens	,
    tb1.flesch_reading_ease	,
    tb1.flesch_kincaid_grade,	
    tb1.product_discription_value
FROM comp_4449_final.stagenewproductdiscription as tb1
INNER JOIN (SELECT *,
			DENSE_RANK() OVER (PARTITION BY
								 prodID
								ORDER BY
								 score_avg DESC
							) score_rank
				FROM ( SELECT PRODID,
						ProductDiscritonID,
						avg(flesch_reading_ease+flesch_kincaid_grade+product_discription_Value) score_avg
						fROM comp_4449_final.stagenewproductdiscription
						GROUP BY PRODID,ProductDiscritonID)as tbnone) as tb2
	ON tb1.prodID = tb2.prodID
    and tb1.ProductDiscritonID = tb2.ProductDiscritonID
WHERE tb2.score_rank = 1;

