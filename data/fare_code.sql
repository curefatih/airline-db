---- CREATE FARE CODE
INSERT INTO FARE_CODE(Code, Description, Reward_ratio)
VALUES (
        'SUPER_EKO',
        'EN KÜÇÜK PAKET. YALNIZCA KABİN BAGAJI',
        0.5
    );
INSERT INTO FARE_CODE(Code, Description, Reward_ratio)
VALUES (
        'EKO',
        'EKONOMİK STANDART PAKET. 20KG BAGAJ HAKKI',
        0.7
    );
INSERT INTO FARE_CODE(Code, Description, Reward_ratio)
VALUES (
        'AVANTAJ',
        'STANDART PAKET + 20KG BAGAJ + SANDVİÇ + UÇAK İÇİ HİZMET.',
        1
    );
INSERT INTO FARE_CODE(Code, Description, Reward_ratio)
VALUES (
        'BUSINESS_FLEX',
        'AVANTAJ PAKET DAHA FAZLA SAYILARLA.',
        1.5
    );