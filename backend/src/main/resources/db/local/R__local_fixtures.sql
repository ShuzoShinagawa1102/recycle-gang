-- Local profile only. Never mix fixtures into the production migration location.
INSERT INTO customer VALUES ('local-user', 'リサイクル 太郎', 'demo@example.test', '090-0000-0000') ON CONFLICT DO NOTHING;
INSERT INTO customer_address VALUES ('home', 'local-user', '自宅', '100-0001', '東京都', '千代田区千代田1（ローカル確認用）') ON CONFLICT DO NOTHING;
INSERT INTO facility VALUES
('tokyo-east', '東エリア リサイクルステーション', '東京都江東区（デモ施設・実在の受付場所ではありません）', 35.672, 139.818, '入口でQRコードを提示し、係員の案内に従って品物を置いてください。写真を撮って「捨てました！」を押すと完了です。'),
('tokyo-west', '西エリア リサイクルステーション', '東京都新宿区（デモ施設・実在の受付場所ではありません）', 35.693, 139.703, '分別して持ち込み、入口でQRコードをご提示ください。') ON CONFLICT DO NOTHING;
INSERT INTO item_type VALUES
('paper', '古紙・段ボール', '束', 0),
('metal', '金属・小物', '袋', 300),
('appliance', '小型家電', '点', 800) ON CONFLICT DO NOTHING;
