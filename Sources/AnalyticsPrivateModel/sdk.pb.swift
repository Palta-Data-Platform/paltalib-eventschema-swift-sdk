// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: sdk.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

/// This proto file is edited manually
/// Run `paltabrain-build-python-sdk` to rebuild module

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public struct EventCommon {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var eventTs: Int64 = 0

  public var sessionID: Int64 {
    get {return _sessionID ?? 0}
    set {_sessionID = newValue}
  }
  /// Returns true if `sessionID` has been explicitly set.
  public var hasSessionID: Bool {return self._sessionID != nil}
  /// Clears the value of `sessionID`. Subsequent reads from it will return its default value.
  public mutating func clearSessionID() {self._sessionID = nil}

  public var sessionEventSeqNum: Int64 {
    get {return _sessionEventSeqNum ?? 0}
    set {_sessionEventSeqNum = newValue}
  }
  /// Returns true if `sessionEventSeqNum` has been explicitly set.
  public var hasSessionEventSeqNum: Bool {return self._sessionEventSeqNum != nil}
  /// Clears the value of `sessionEventSeqNum`. Subsequent reads from it will return its default value.
  public mutating func clearSessionEventSeqNum() {self._sessionEventSeqNum = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _sessionID: Int64? = nil
  fileprivate var _sessionEventSeqNum: Int64? = nil
}

public struct Event {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var common: EventCommon {
    get {return _common ?? EventCommon()}
    set {_common = newValue}
  }
  /// Returns true if `common` has been explicitly set.
  public var hasCommon: Bool {return self._common != nil}
  /// Clears the value of `common`. Subsequent reads from it will return its default value.
  public mutating func clearCommon() {self._common = nil}

  public var header: Data = Data()

  public var payload: Data = Data()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _common: EventCommon? = nil
}

public struct BatchCommon {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var instanceID: String = String()

  public var batchID: String = String()

  public var countryCode: String {
    get {return _countryCode ?? String()}
    set {_countryCode = newValue}
  }
  /// Returns true if `countryCode` has been explicitly set.
  public var hasCountryCode: Bool {return self._countryCode != nil}
  /// Clears the value of `countryCode`. Subsequent reads from it will return its default value.
  public mutating func clearCountryCode() {self._countryCode = nil}

  public var locale: String {
    get {return _locale ?? String()}
    set {_locale = newValue}
  }
  /// Returns true if `locale` has been explicitly set.
  public var hasLocale: Bool {return self._locale != nil}
  /// Clears the value of `locale`. Subsequent reads from it will return its default value.
  public mutating func clearLocale() {self._locale = nil}

  public var utcOffset: Int64 {
    get {return _utcOffset ?? 0}
    set {_utcOffset = newValue}
  }
  /// Returns true if `utcOffset` has been explicitly set.
  public var hasUtcOffset: Bool {return self._utcOffset != nil}
  /// Clears the value of `utcOffset`. Subsequent reads from it will return its default value.
  public mutating func clearUtcOffset() {self._utcOffset = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _countryCode: String? = nil
  fileprivate var _locale: String? = nil
  fileprivate var _utcOffset: Int64? = nil
}

public struct BatchTelemetry {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var eventsDropped: Int64 {
    get {return _eventsDropped ?? 0}
    set {_eventsDropped = newValue}
  }
  /// Returns true if `eventsDropped` has been explicitly set.
  public var hasEventsDropped: Bool {return self._eventsDropped != nil}
  /// Clears the value of `eventsDropped`. Subsequent reads from it will return its default value.
  public mutating func clearEventsDropped() {self._eventsDropped = nil}

  public var prevConnectionSpeed: String {
    get {return _prevConnectionSpeed ?? String()}
    set {_prevConnectionSpeed = newValue}
  }
  /// Returns true if `prevConnectionSpeed` has been explicitly set.
  public var hasPrevConnectionSpeed: Bool {return self._prevConnectionSpeed != nil}
  /// Clears the value of `prevConnectionSpeed`. Subsequent reads from it will return its default value.
  public mutating func clearPrevConnectionSpeed() {self._prevConnectionSpeed = nil}

  public var prevRequestTime: Int64 {
    get {return _prevRequestTime ?? 0}
    set {_prevRequestTime = newValue}
  }
  /// Returns true if `prevRequestTime` has been explicitly set.
  public var hasPrevRequestTime: Bool {return self._prevRequestTime != nil}
  /// Clears the value of `prevRequestTime`. Subsequent reads from it will return its default value.
  public mutating func clearPrevRequestTime() {self._prevRequestTime = nil}

  public var eventsReportingSpeed: String {
    get {return _eventsReportingSpeed ?? String()}
    set {_eventsReportingSpeed = newValue}
  }
  /// Returns true if `eventsReportingSpeed` has been explicitly set.
  public var hasEventsReportingSpeed: Bool {return self._eventsReportingSpeed != nil}
  /// Clears the value of `eventsReportingSpeed`. Subsequent reads from it will return its default value.
  public mutating func clearEventsReportingSpeed() {self._eventsReportingSpeed = nil}

  public var serializationErrors: [String] = []

  public var storageErrors: [String] = []

  public var storageUsed: String {
    get {return _storageUsed ?? String()}
    set {_storageUsed = newValue}
  }
  /// Returns true if `storageUsed` has been explicitly set.
  public var hasStorageUsed: Bool {return self._storageUsed != nil}
  /// Clears the value of `storageUsed`. Subsequent reads from it will return its default value.
  public mutating func clearStorageUsed() {self._storageUsed = nil}

  public var triggerType: String {
    get {return _triggerType ?? String()}
    set {_triggerType = newValue}
  }
  /// Returns true if `triggerType` has been explicitly set.
  public var hasTriggerType: Bool {return self._triggerType != nil}
  /// Clears the value of `triggerType`. Subsequent reads from it will return its default value.
  public mutating func clearTriggerType() {self._triggerType = nil}

  public var timeSinceLastBatch: Int64 {
    get {return _timeSinceLastBatch ?? 0}
    set {_timeSinceLastBatch = newValue}
  }
  /// Returns true if `timeSinceLastBatch` has been explicitly set.
  public var hasTimeSinceLastBatch: Bool {return self._timeSinceLastBatch != nil}
  /// Clears the value of `timeSinceLastBatch`. Subsequent reads from it will return its default value.
  public mutating func clearTimeSinceLastBatch() {self._timeSinceLastBatch = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _eventsDropped: Int64? = nil
  fileprivate var _prevConnectionSpeed: String? = nil
  fileprivate var _prevRequestTime: Int64? = nil
  fileprivate var _eventsReportingSpeed: String? = nil
  fileprivate var _storageUsed: String? = nil
  fileprivate var _triggerType: String? = nil
  fileprivate var _timeSinceLastBatch: Int64? = nil
}

public struct Batch {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var common: BatchCommon {
    get {return _common ?? BatchCommon()}
    set {_common = newValue}
  }
  /// Returns true if `common` has been explicitly set.
  public var hasCommon: Bool {return self._common != nil}
  /// Clears the value of `common`. Subsequent reads from it will return its default value.
  public mutating func clearCommon() {self._common = nil}

  public var context: Data = Data()

  public var events: [Event] = []

  public var telemetry: BatchTelemetry {
    get {return _telemetry ?? BatchTelemetry()}
    set {_telemetry = newValue}
  }
  /// Returns true if `telemetry` has been explicitly set.
  public var hasTelemetry: Bool {return self._telemetry != nil}
  /// Clears the value of `telemetry`. Subsequent reads from it will return its default value.
  public mutating func clearTelemetry() {self._telemetry = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _common: BatchCommon? = nil
  fileprivate var _telemetry: BatchTelemetry? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension EventCommon: @unchecked Sendable {}
extension Event: @unchecked Sendable {}
extension BatchCommon: @unchecked Sendable {}
extension BatchTelemetry: @unchecked Sendable {}
extension Batch: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension EventCommon: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "EventCommon"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "event_ts"),
    2: .standard(proto: "session_id"),
    3: .standard(proto: "session_event_seq_num"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularSInt64Field(value: &self.eventTs) }()
      case 2: try { try decoder.decodeSingularSInt64Field(value: &self._sessionID) }()
      case 3: try { try decoder.decodeSingularSInt64Field(value: &self._sessionEventSeqNum) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.eventTs != 0 {
      try visitor.visitSingularSInt64Field(value: self.eventTs, fieldNumber: 1)
    }
    try { if let v = self._sessionID {
      try visitor.visitSingularSInt64Field(value: v, fieldNumber: 2)
    } }()
    try { if let v = self._sessionEventSeqNum {
      try visitor.visitSingularSInt64Field(value: v, fieldNumber: 3)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: EventCommon, rhs: EventCommon) -> Bool {
    if lhs.eventTs != rhs.eventTs {return false}
    if lhs._sessionID != rhs._sessionID {return false}
    if lhs._sessionEventSeqNum != rhs._sessionEventSeqNum {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Event: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "Event"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "common"),
    2: .same(proto: "header"),
    3: .same(proto: "payload"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._common) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.header) }()
      case 3: try { try decoder.decodeSingularBytesField(value: &self.payload) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._common {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if !self.header.isEmpty {
      try visitor.visitSingularBytesField(value: self.header, fieldNumber: 2)
    }
    if !self.payload.isEmpty {
      try visitor.visitSingularBytesField(value: self.payload, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Event, rhs: Event) -> Bool {
    if lhs._common != rhs._common {return false}
    if lhs.header != rhs.header {return false}
    if lhs.payload != rhs.payload {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension BatchCommon: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "BatchCommon"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "instance_id"),
    2: .standard(proto: "batch_id"),
    3: .standard(proto: "country_code"),
    4: .same(proto: "locale"),
    5: .standard(proto: "utc_offset"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.instanceID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.batchID) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self._countryCode) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self._locale) }()
      case 5: try { try decoder.decodeSingularSInt64Field(value: &self._utcOffset) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.instanceID.isEmpty {
      try visitor.visitSingularStringField(value: self.instanceID, fieldNumber: 1)
    }
    if !self.batchID.isEmpty {
      try visitor.visitSingularStringField(value: self.batchID, fieldNumber: 2)
    }
    try { if let v = self._countryCode {
      try visitor.visitSingularStringField(value: v, fieldNumber: 3)
    } }()
    try { if let v = self._locale {
      try visitor.visitSingularStringField(value: v, fieldNumber: 4)
    } }()
    try { if let v = self._utcOffset {
      try visitor.visitSingularSInt64Field(value: v, fieldNumber: 5)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: BatchCommon, rhs: BatchCommon) -> Bool {
    if lhs.instanceID != rhs.instanceID {return false}
    if lhs.batchID != rhs.batchID {return false}
    if lhs._countryCode != rhs._countryCode {return false}
    if lhs._locale != rhs._locale {return false}
    if lhs._utcOffset != rhs._utcOffset {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension BatchTelemetry: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "BatchTelemetry"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "events_dropped"),
    2: .standard(proto: "prev_connection_speed"),
    3: .standard(proto: "prev_request_time"),
    4: .standard(proto: "events_reporting_speed"),
    5: .standard(proto: "serialization_errors"),
    6: .standard(proto: "storage_errors"),
    7: .standard(proto: "storage_used"),
    8: .standard(proto: "trigger_type"),
    9: .standard(proto: "time_since_last_batch"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularSInt64Field(value: &self._eventsDropped) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self._prevConnectionSpeed) }()
      case 3: try { try decoder.decodeSingularSInt64Field(value: &self._prevRequestTime) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self._eventsReportingSpeed) }()
      case 5: try { try decoder.decodeRepeatedStringField(value: &self.serializationErrors) }()
      case 6: try { try decoder.decodeRepeatedStringField(value: &self.storageErrors) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self._storageUsed) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self._triggerType) }()
      case 9: try { try decoder.decodeSingularSInt64Field(value: &self._timeSinceLastBatch) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._eventsDropped {
      try visitor.visitSingularSInt64Field(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._prevConnectionSpeed {
      try visitor.visitSingularStringField(value: v, fieldNumber: 2)
    } }()
    try { if let v = self._prevRequestTime {
      try visitor.visitSingularSInt64Field(value: v, fieldNumber: 3)
    } }()
    try { if let v = self._eventsReportingSpeed {
      try visitor.visitSingularStringField(value: v, fieldNumber: 4)
    } }()
    if !self.serializationErrors.isEmpty {
      try visitor.visitRepeatedStringField(value: self.serializationErrors, fieldNumber: 5)
    }
    if !self.storageErrors.isEmpty {
      try visitor.visitRepeatedStringField(value: self.storageErrors, fieldNumber: 6)
    }
    try { if let v = self._storageUsed {
      try visitor.visitSingularStringField(value: v, fieldNumber: 7)
    } }()
    try { if let v = self._triggerType {
      try visitor.visitSingularStringField(value: v, fieldNumber: 8)
    } }()
    try { if let v = self._timeSinceLastBatch {
      try visitor.visitSingularSInt64Field(value: v, fieldNumber: 9)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: BatchTelemetry, rhs: BatchTelemetry) -> Bool {
    if lhs._eventsDropped != rhs._eventsDropped {return false}
    if lhs._prevConnectionSpeed != rhs._prevConnectionSpeed {return false}
    if lhs._prevRequestTime != rhs._prevRequestTime {return false}
    if lhs._eventsReportingSpeed != rhs._eventsReportingSpeed {return false}
    if lhs.serializationErrors != rhs.serializationErrors {return false}
    if lhs.storageErrors != rhs.storageErrors {return false}
    if lhs._storageUsed != rhs._storageUsed {return false}
    if lhs._triggerType != rhs._triggerType {return false}
    if lhs._timeSinceLastBatch != rhs._timeSinceLastBatch {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Batch: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "Batch"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "common"),
    2: .same(proto: "context"),
    3: .same(proto: "events"),
    4: .same(proto: "telemetry"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._common) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.context) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.events) }()
      case 4: try { try decoder.decodeSingularMessageField(value: &self._telemetry) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._common {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if !self.context.isEmpty {
      try visitor.visitSingularBytesField(value: self.context, fieldNumber: 2)
    }
    if !self.events.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.events, fieldNumber: 3)
    }
    try { if let v = self._telemetry {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Batch, rhs: Batch) -> Bool {
    if lhs._common != rhs._common {return false}
    if lhs.context != rhs.context {return false}
    if lhs.events != rhs.events {return false}
    if lhs._telemetry != rhs._telemetry {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
