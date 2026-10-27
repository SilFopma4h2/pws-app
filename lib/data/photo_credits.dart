// AANPASBARE PWS-INHOUD
// Herkomst van de foto's in assets/images/. Alle foto's komen van Wikimedia
// Commons. Bij CC BY en CC BY-SA is naamsvermelding verplicht; deze lijst
// wordt getoond op het Info-scherm. Vervang je een foto, pas dan ook de
// regel hier aan.

class PhotoCredit {
  const PhotoCredit({
    required this.subject,
    required this.author,
    required this.license,
    required this.url,
  });

  final String subject;
  final String author;
  final String license;
  final String url;
}

const List<PhotoCredit> photoCredits = [
  PhotoCredit(
    subject: 'Airborne Museum Hartenstein',
    author: 'Paul Hermans',
    license: 'CC BY-SA 4.0',
    url:
        'https://commons.wikimedia.org/wiki/File:Airborne_Museum_Hartenstein_Oosterbeek_23-04-2019.jpg',
  ),
  PhotoCredit(
    subject: 'Arnhem Oosterbeek War Cemetery',
    author: 'Pior',
    license: 'Publiek domein',
    url:
        'https://commons.wikimedia.org/wiki/File:Arnhem_Oosterbeek_War_Cemetery.jpg',
  ),
  PhotoCredit(
    subject: 'De Oude Kerk, Oosterbeek',
    author: 'Michielverbeek',
    license: 'CC BY-SA 4.0',
    url:
        'https://commons.wikimedia.org/wiki/File:Oosterbeek,_de_Oude_Kerk_RM32432_IMG_4215_2020-04-08_09.09.jpg',
  ),
  PhotoCredit(
    subject: 'Beukenlaan in Oosterbeek (Mortierput)',
    author: 'Henk Monster',
    license: 'CC BY 3.0',
    url:
        'https://commons.wikimedia.org/wiki/File:Nice_Beech_lane_at_Oosterbeek_at_12_October_2015_-_panoramio.jpg',
  ),
  PhotoCredit(
    subject: 'Mortier bij Arnhem, 20 september 1944',
    author: 'No 5 Army Film & Photographic Unit / Nationaal Archief',
    license: 'CC0',
    url:
        'https://commons.wikimedia.org/wiki/File:3_Inch_Mortars,_20-9-1944,_Battle_of_Arnhem,_Bestanddeelnr_24023_061.tif',
  ),
  PhotoCredit(
    subject: 'Hotel Dreyeroord',
    author: 'J.J. Bats',
    license: 'CC BY-SA 4.0',
    url: 'https://commons.wikimedia.org/wiki/File:Dreijeroord-1506362016.JPG',
  ),
  PhotoCredit(
    subject: 'Engineers-monument, Driel',
    author: 'Bj.schoenmakers',
    license: 'CC0',
    url:
        'https://commons.wikimedia.org/wiki/File:Engineers_monument,_Driel,_the_Netherlands.jpg',
  ),
  PhotoCredit(
    subject: 'Airborne-monument bij de John Frostbrug',
    author: 'Michielverbeek',
    license: 'CC BY-SA 4.0',
    url:
        'https://commons.wikimedia.org/wiki/File:Arnhem_centrum,_Airbornemonument_Jacob_Groenewoudplantsoen_met_John_Frostbrug_op_achtergrond_foto3_2015-06-30_18.12.jpg',
  ),
  PhotoCredit(
    subject: 'De John Frostbrug',
    author: 'Michielverbeek',
    license: 'CC BY-SA 4.0',
    url:
        'https://commons.wikimedia.org/wiki/File:Arnhem,_de_John_Frostbrug_foto3_2015-12-30_10.10.jpg',
  ),
];
