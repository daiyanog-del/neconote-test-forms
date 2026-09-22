-- ネコノテアクション フォーム営業の動作検証用ダミー宛先（3社）を本番 recipients_market に投入する。
-- 検証後は末尾の「後始末」を実行して status='removed' に戻すこと。
-- 画面の絞り込みは「テーマ→キーワード」「都道府県」「連絡手段」のみ（業種・社名では探せない）。
-- seed_keyword は既存テーマに属する値（サウナ→テーマ「サウナ・浴場」）にしておく。
-- corporate_number は実在しない 9999999999xxx 系（法人番号は13桁）。

INSERT INTO recipients_market
  (corporate_number, company_name, email, contact_method, contact_form_url, form_fields,
   industry, area_prefecture, area_city, website_url, source_url,
   source_confirmed_no_optout, company_profile, business_summary, crawled_at, status, created_at)
VALUES
  ('9999999999001', 'テスト株式会社（ネコノテ検証用・標準フォーム）', NULL, 'form',
   'https://daiyanog-del.github.io/neconote-test-forms/contact.html',
   '{"fields": ["company","name","email","tel","kind","message","agree"]}',
   '洗濯・理容・美容・浴場業', '東京都', '千代田区架空町1-2-3',
   'https://daiyanog-del.github.io/neconote-test-forms/',
   'https://daiyanog-del.github.io/neconote-test-forms/contact.html',
   TRUE,
   '{"summary": "ネコノテアクションの動作検証用ダミー企業。実在しません。", "seed_keyword": "サウナ", "official_name": "テスト株式会社（ネコノテ検証用）", "is_same_company": true}',
   'ネコノテアクションの動作検証用ダミー企業（標準フォーム）', NOW(), 'active', NOW()),

  ('9999999999002', 'テスト株式会社（ネコノテ検証用・詳細フォーム）', NULL, 'form',
   'https://daiyanog-del.github.io/neconote-test-forms/contact2.html',
   '{"fields": ["company","department","position","sei","mei","sei_kana","mei_kana","zip","pref","address","tel1","tel2","tel3","email","email_confirm","url","subject","message","agree"]}',
   '洗濯・理容・美容・浴場業', '東京都', '千代田区架空町1-2-3',
   'https://daiyanog-del.github.io/neconote-test-forms/',
   'https://daiyanog-del.github.io/neconote-test-forms/contact2.html',
   TRUE,
   '{"summary": "ネコノテアクションの動作検証用ダミー企業。実在しません。", "seed_keyword": "サウナ", "official_name": "テスト株式会社（ネコノテ検証用）", "is_same_company": true}',
   'ネコノテアクションの動作検証用ダミー企業（姓名分割・電話3分割・確認画面あり）', NOW(), 'active', NOW()),

  ('9999999999003', 'テスト株式会社（ネコノテ検証用・営業お断りページ）', NULL, 'form',
   'https://daiyanog-del.github.io/neconote-test-forms/no-sales.html',
   '{"fields": ["company","name","email","tel","kind","message","agree"]}',
   '洗濯・理容・美容・浴場業', '東京都', '千代田区架空町1-2-3',
   'https://daiyanog-del.github.io/neconote-test-forms/',
   'https://daiyanog-del.github.io/neconote-test-forms/no-sales.html',
   TRUE,
   '{"summary": "ネコノテアクションの動作検証用ダミー企業。実在しません。", "seed_keyword": "サウナ", "official_name": "テスト株式会社（ネコノテ検証用）", "is_same_company": true}',
   'ネコノテアクションの動作検証用ダミー企業（送信直前チェックで止まることの確認用）', NOW(), 'active', NOW());

-- 後始末（検証後に実行）
-- UPDATE recipients_market SET status='removed' WHERE corporate_number LIKE '9999999999%';
