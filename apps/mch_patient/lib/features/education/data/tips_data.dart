import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TipCategory {
  pregnancy,
  baby,
  nutrition,
  health,
  development,
  general,
}

class Tip {
  final String id;
  final String content; // The actual tip text
  final TipCategory category;
  final String? title; // Optional title
  final int? minPregnancyWeek;
  final int? maxPregnancyWeek;
  final int? minChildAgeMonths;
  final int? maxChildAgeMonths;
  final IconData? icon;

  const Tip({
    required this.id,
    required this.content,
    required this.category,
    this.title,
    this.minPregnancyWeek,
    this.maxPregnancyWeek,
    this.minChildAgeMonths,
    this.maxChildAgeMonths,
    this.icon,
  });
}

class TipsRepository {
  static const List<Tip> allTips = [
    // --- PREGNANCY TIPS ---

    // First Trimester (0-12 weeks)
    Tip(
      id: 'preg_1',
      category: TipCategory.pregnancy,
      title: 'Take your Folic Acid',
      content:
          'Folic acid fits birth defects of the brain and spine. Take it daily!',
      minPregnancyWeek: 0,
      maxPregnancyWeek: 12,
      icon: Icons.medication,
    ),
    Tip(
      id: 'preg_2',
      category: TipCategory.nutrition,
      title: 'Morning Sickness?',
      content:
          'Eat small, frequent meals to help with nausea. Ginger tea can also help.',
      minPregnancyWeek: 0,
      maxPregnancyWeek: 16,
      icon: Icons.local_dining,
    ),
    Tip(
      id: 'preg_3',
      category: TipCategory.pregnancy,
      title: 'First Antenatal Visit',
      content:
          'Start your antenatal clinics as soon as you realize you are pregnant.',
      minPregnancyWeek: 0,
      maxPregnancyWeek: 12,
      icon: Icons.calendar_today,
    ),

    // Second Trimester (13-26 weeks)
    Tip(
      id: 'preg_4',
      category: TipCategory.pregnancy,
      title: 'Baby is moving!',
      content:
          'You might start feeling your baby move (quickening) around 16-20 weeks.',
      minPregnancyWeek: 16,
      maxPregnancyWeek: 24,
      icon: Icons.child_care,
    ),
    Tip(
      id: 'preg_5',
      category: TipCategory.nutrition,
      title: 'Iron is important',
      content:
          'Eat iron-rich foods like spinach, meat, and beans to prevent anemia.',
      minPregnancyWeek: 13,
      maxPregnancyWeek: 40,
      icon: Icons.restaurant,
    ),

    // Third Trimester (27-40 weeks)
    Tip(
      id: 'preg_6',
      category: TipCategory.pregnancy,
      title: 'Pack your Hospital Bag',
      content:
          'Have your hospital bag ready by 36 weeks. Include baby clothes and your ID.',
      minPregnancyWeek: 30,
      maxPregnancyWeek: 40,
      icon: Icons.shopping_bag,
    ),
    Tip(
      id: 'preg_7',
      category: TipCategory.health,
      title: 'Danger Signs',
      content:
          'If you experience severe headache, blurred vision, or bleeding, go to the hospital immediately.',
      minPregnancyWeek: 20,
      maxPregnancyWeek: 42,
      icon: Icons.warning_amber,
    ),

    // --- CHILD TIPS ---

    // Newborn (0-1 month)
    Tip(
      id: 'child_1',
      category: TipCategory.baby,
      title: 'Breastfeeding',
      content:
          'Breastfeed your baby exclusively for the first 6 months. No water needed!',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 6,
      icon: FontAwesomeIcons.personBreastfeeding,
    ),
    Tip(
      id: 'child_2',
      category: TipCategory.health,
      title: 'Vaccination: BCG & Polio',
      content:
          'Ensure your baby gets the BCG and Birth Polio vaccine immediately after birth.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 1,
      icon: Icons.vaccines,
    ),

    // Infant (1-6 months)
    Tip(
      id: 'child_3',
      category: TipCategory.health,
      title: 'Vaccination: 6 Weeks',
      content:
          'At 6 weeks, your baby needs the Penta 1, Polio 1, PCV 1, and Rotavirus 1 vaccines.',
      minChildAgeMonths: 1,
      maxChildAgeMonths: 2,
      icon: Icons.vaccines,
    ),
    Tip(
      id: 'child_4',
      category: TipCategory.development,
      title: 'Tummy Time',
      content:
          'Give your baby supervised tummy time to strengthen their neck and back muscles.',
      minChildAgeMonths: 2,
      maxChildAgeMonths: 6,
      icon: Icons.baby_changing_station,
    ),

    // Older Infant (6-12 months)
    Tip(
      id: 'child_5',
      category: TipCategory.nutrition,
      title: 'Starting Solids',
      content:
          'At 6 months, start giving soft porridge or mashed food while continuing to breastfeed.',
      minChildAgeMonths: 6,
      maxChildAgeMonths: 12,
      icon: Icons.rice_bowl,
    ),
    Tip(
      id: 'child_6',
      category: TipCategory.health,
      title: 'Vitamin A',
      content:
          'Make sure your child gets Vitamin A supplementation starting at 6 months.',
      minChildAgeMonths: 6,
      maxChildAgeMonths: 60, // up to 5 years
      icon: Icons.medication_liquid,
    ),

    // Toddler (12-24 months)
    Tip(
      id: 'child_7',
      category: TipCategory.health,
      title: 'Measles Vaccine',
      content:
          'Your child needs the Measles vaccine at 9 months and 18 months.',
      minChildAgeMonths: 9,
      maxChildAgeMonths: 19,
      icon: Icons.vaccines,
    ),

    // --- FAMILY PLANNING (from Resources) ---
    Tip(
      id: 'fp_1',
      category: TipCategory.health, // or general
      title: 'Birth Spacing',
      content:
          'Wait at least 24 months before your next pregnancy for better health outcomes.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 24,
      icon: FontAwesomeIcons.child,
    ),
    Tip(
      id: 'fp_2',
      category: TipCategory.health,
      title: 'Contraception',
      content:
          'Explore different contraceptive methods to decide what is best for you and your family.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 60,
      icon: FontAwesomeIcons.pills,
    ),

    // --- MUST KNOW (from Must Know Screen) ---
    Tip(
      id: 'mk_1',
      category: TipCategory.health,
      title: 'When to Return',
      content:
          'Return immediately if your child has a fever, is vomiting, or cannot breastfeed.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 60,
      icon: Icons.medical_services,
    ),
    Tip(
      id: 'mk_2',
      category: TipCategory.nutrition,
      title: 'Fluids for Sick Child',
      content:
          'Give your child more fluids than usual if they have diarrhoea or fever.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 60,
      icon: Icons.water_drop,
    ),
    Tip(
      id: 'mk_3',
      category: TipCategory.nutrition,
      title: 'Healthy Diet',
      content:
          'Include a variety of foods from the 10 food groups in your child\'s diet.',
      minChildAgeMonths: 6,
      maxChildAgeMonths: 60,
      icon: Icons.local_dining,
    ),

    // --- GENERAL / HANDBOOK EXTRACTS ---
    Tip(
      id: 'hb_1',
      category: TipCategory.health,
      title: 'Hand Washing',
      content:
          'Always wash your hands with soap and water before handling the baby.',
      icon: Icons.wash,
    ),
    Tip(
      id: 'hb_2',
      category: TipCategory.health,
      title: 'Sleep Safe',
      content: 'Always put your baby to sleep on their back to prevent SIDS.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 12,
      icon: FontAwesomeIcons.bed,
    ),
    Tip(
      id: 'hb_3',
      category: TipCategory.health,
      title: 'Cord Care',
      content:
          'Keep the umbilical cord stump dry and clean. Do not apply anything unless advised by a doctor.',
      minChildAgeMonths: 0,
      maxChildAgeMonths: 1,
      icon: Icons.health_and_safety,
    ),
  ];
}
