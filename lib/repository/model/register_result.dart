class RegisterResult {
  Result result;
  Connection connection;
  int modifiedCount;
  Null upsertedId;
  int upsertedCount;
  int matchedCount;
  int n;
  int nModified;
  OpTime opTime;
  String electionId;
  int ok;
  String operationTime;
  ClusterTime clusterTime;

  RegisterResult(
      {this.result,
        this.connection,
        this.modifiedCount,
        this.upsertedId,
        this.upsertedCount,
        this.matchedCount,
        this.n,
        this.nModified,
        this.opTime,
        this.electionId,
        this.ok,
        this.operationTime,
        this.clusterTime});

  RegisterResult.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    connection = json['connection'] != null
        ? new Connection.fromJson(json['connection'])
        : null;
    modifiedCount = json['modifiedCount'];
    upsertedId = json['upsertedId'];
    upsertedCount = json['upsertedCount'];
    matchedCount = json['matchedCount'];
    n = json['n'];
    nModified = json['nModified'];
    opTime =
    json['opTime'] != null ? new OpTime.fromJson(json['opTime']) : null;
    electionId = json['electionId'];
    ok = json['ok'];
    operationTime = json['operationTime'];
    clusterTime = json['$clusterTime'] != null
        ? new ClusterTime.fromJson(json['$clusterTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    if (this.connection != null) {
      data['connection'] = this.connection.toJson();
    }
    data['modifiedCount'] = this.modifiedCount;
    data['upsertedId'] = this.upsertedId;
    data['upsertedCount'] = this.upsertedCount;
    data['matchedCount'] = this.matchedCount;
    data['n'] = this.n;
    data['nModified'] = this.nModified;
    if (this.opTime != null) {
      data['opTime'] = this.opTime.toJson();
    }
    data['electionId'] = this.electionId;
    data['ok'] = this.ok;
    data['operationTime'] = this.operationTime;
    if (this.clusterTime != null) {
      data['$clusterTime'] = this.clusterTime.toJson();
    }
    return data;
  }
}

class Result {
  int n;
  int nModified;
  OpTime opTime;
  String electionId;
  int ok;
  String operationTime;
  ClusterTime clusterTime;

  Result(
      {this.n,
        this.nModified,
        this.opTime,
        this.electionId,
        this.ok,
        this.operationTime,
        this.clusterTime});

  Result.fromJson(Map<String, dynamic> json) {
    n = json['n'];
    nModified = json['nModified'];
    opTime =
    json['opTime'] != null ? new OpTime.fromJson(json['opTime']) : null;
    electionId = json['electionId'];
    ok = json['ok'];
    operationTime = json['operationTime'];
    clusterTime = json['$clusterTime'] != null
        ? new ClusterTime.fromJson(json['$clusterTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['n'] = this.n;
    data['nModified'] = this.nModified;
    if (this.opTime != null) {
      data['opTime'] = this.opTime.toJson();
    }
    data['electionId'] = this.electionId;
    data['ok'] = this.ok;
    data['operationTime'] = this.operationTime;
    if (this.clusterTime != null) {
      data['$clusterTime'] = this.clusterTime.toJson();
    }
    return data;
  }
}

class OpTime {
  String ts;
  int t;

  OpTime({this.ts, this.t});

  OpTime.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    t = json['t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ts'] = this.ts;
    data['t'] = this.t;
    return data;
  }
}

class ClusterTime {
  String clusterTime;
  Signature signature;

  ClusterTime({this.clusterTime, this.signature});

  ClusterTime.fromJson(Map<String, dynamic> json) {
    clusterTime = json['clusterTime'];
    signature = json['signature'] != null
        ? new Signature.fromJson(json['signature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clusterTime'] = this.clusterTime;
    if (this.signature != null) {
      data['signature'] = this.signature.toJson();
    }
    return data;
  }
}

class Signature {
  String hash;
  String keyId;

  Signature({this.hash, this.keyId});

  Signature.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    keyId = json['keyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['keyId'] = this.keyId;
    return data;
  }
}

class Connection {
  int id;
  String host;
  int port;

  Connection({this.id, this.host, this.port});

  Connection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    host = json['host'];
    port = json['port'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['host'] = this.host;
    data['port'] = this.port;
    return data;
  }
}