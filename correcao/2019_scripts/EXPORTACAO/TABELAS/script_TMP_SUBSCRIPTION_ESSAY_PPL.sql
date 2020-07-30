select sbc.*, bte.result, bte.processed_key, bte.original_key
into tmp_sbuscription_essay
 from subscriptions_subscription sbc left join batch_essay bte on (bte.id = sbc.essay_id)