import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mch_health_worker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create maternal_profiles table based on MCH Handbook Section 1 (Page 5)
    await db.execute('''
      CREATE TABLE maternal_profiles(
        id TEXT PRIMARY KEY,
        facilityName TEXT NOT NULL,
        kmhflCode TEXT NOT NULL,
        ancNumber TEXT NOT NULL,
        pncNumber TEXT,
        
        clientName TEXT NOT NULL,
        age INTEGER NOT NULL,
        gravida INTEGER NOT NULL,
        parity INTEGER NOT NULL,
        heightCm REAL NOT NULL,
        weightKg REAL NOT NULL,
        lmp TEXT NOT NULL,
        edd TEXT NOT NULL,
        maritalStatus TEXT,
        
        county TEXT,
        subCounty TEXT,
        ward TEXT,
        village TEXT,
        physicalAddress TEXT,
        telephone TEXT,
        educationLevel TEXT,
        
        nextOfKinName TEXT,
        nextOfKinRelationship TEXT,
        nextOfKinPhone TEXT,
        
        surgicalOperation TEXT,
        diabetes INTEGER,
        hypertension INTEGER,
        bloodTransfusion INTEGER,
        tuberculosis INTEGER,
        drugAllergy INTEGER,
        allergyDetails TEXT,
        
        familyHistoryTwins INTEGER,
        familyHistoryTB INTEGER,
        
        haemoglobin REAL,
        bloodGroup TEXT,
        rhesus TEXT,
        urinalysis TEXT,
        bloodSugar REAL,
        
        tbScreeningDone INTEGER,
        tbScreeningPositive INTEGER,
        tbScreeningDate TEXT,
        
        firstUltrasoundDate TEXT,
        firstUltrasoundGestation INTEGER,
        secondUltrasoundDate TEXT,
        secondUltrasoundGestation INTEGER,
        
        hivResult TEXT,
        hivTestDate TEXT,
        syphilisResult TEXT,
        syphilisTestDate TEXT,
        hepatitisBResult TEXT,
        hepatitisBTestDate TEXT,
        
        coupleTestingDone INTEGER,
        partnerHivStatus TEXT,
        
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // Create anc_visits table (Page 8 - Present Pregnancy Table)
    await db.execute('''
      CREATE TABLE anc_visits(
        id TEXT PRIMARY KEY,
        maternalProfileId TEXT NOT NULL,
        visitNumber INTEGER NOT NULL,
        visitDate TEXT NOT NULL,
        gestationWeeks INTEGER NOT NULL,
        weight REAL,
        bloodPressure TEXT,
        fundalHeight REAL,
        presentation TEXT,
        lie TEXT,
        fetalHeartRate INTEGER,
        fetalMovement TEXT,
        urineTest TEXT,
        haemoglobin REAL,
        notes TEXT,
        nextVisit TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        FOREIGN KEY (maternalProfileId) REFERENCES maternal_profiles (id) ON DELETE CASCADE
      )
    ''');

    // Create immunizations table (Page 10 - Tetanus/Diphtheria)
    await db.execute('''
      CREATE TABLE immunizations(
        id TEXT PRIMARY KEY,
        maternalProfileId TEXT NOT NULL,
        vaccineType TEXT NOT NULL,
        doseNumber INTEGER NOT NULL,
        dateGiven TEXT NOT NULL,
        nextDueDate TEXT,
        createdAt TEXT,
        FOREIGN KEY (maternalProfileId) REFERENCES maternal_profiles (id) ON DELETE CASCADE
      )
    ''');

    // Create malaria_prophylaxis table (Page 10 - IPTp-SP)
    await db.execute('''
      CREATE TABLE malaria_prophylaxis(
        id TEXT PRIMARY KEY,
        maternalProfileId TEXT NOT NULL,
        doseNumber INTEGER NOT NULL,
        dateGiven TEXT NOT NULL,
        gestationWeeks INTEGER,
        nextDueDate TEXT,
        createdAt TEXT,
        FOREIGN KEY (maternalProfileId) REFERENCES maternal_profiles (id) ON DELETE CASCADE
      )
    ''');

    // Create iron_folic_acid table (Page 10 - IFAS)
    await db.execute('''
      CREATE TABLE iron_folic_acid(
        id TEXT PRIMARY KEY,
        maternalProfileId TEXT NOT NULL,
        contactNumber INTEGER NOT NULL,
        gestationWeeks INTEGER NOT NULL,
        tabletsGiven INTEGER NOT NULL,
        dateGiven TEXT NOT NULL,
        createdAt TEXT,
        FOREIGN KEY (maternalProfileId) REFERENCES maternal_profiles (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}