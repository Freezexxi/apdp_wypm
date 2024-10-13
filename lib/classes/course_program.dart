class CourseProgram {
  final String _programId;
  String programName;
  double feeInMMK;
  String overview;
  String difficultyLevel;

  // Constructor
  CourseProgram({
    required String programId,
    required this.programName,
    required this.feeInMMK,
    required this.overview,
    required this.difficultyLevel,
  }) : _programId = programId;

  // Getter for programId
  String get programId => _programId;

  // Convert Program object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'programId': _programId,
      'programName': programName,
      'feeInMMK': feeInMMK,
      'overview': overview,
      'difficultyLevel': difficultyLevel,
    };
  }

  // Factory method to map Firestore data to Program object
  factory CourseProgram.fromSnapshot(Map<String, dynamic> data) {
    return CourseProgram(
      programId: data['programId'] ?? '',
      programName: data['programName'] ?? '',
      overview: data['overview'] ?? '',
      difficultyLevel: data['difficultyLevel'] ?? '',
      feeInMMK: (data['feeInMMK']).toDouble(),
    );
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //   if (other is! CourseProgram) return false;
  //   return _programId == other._programId &&
  //       programName == other.programName &&
  //       feeInMMK == other.feeInMMK &&
  //       difficultyLevel == other.difficultyLevel &&
  //       overview == other.overview;
  // }
  //
  // @override
  // int get hashCode {
  //   return _programId.hashCode ^
  //   programName.hashCode ^
  //   feeInMMK.hashCode ^
  //   difficultyLevel.hashCode ^
  //   overview.hashCode;
  // }
}
