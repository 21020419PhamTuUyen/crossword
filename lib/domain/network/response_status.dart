class ResponseStatus {
  // Informational
  static const int response100Continue = 100;
  static const int response101SwitchingProtocols = 101;
  static const int response102Processing = 102;
  static const int response103EarlyHints = 103;

  // Successful
  static const int response200Ok = 200;
  static const int response201Created = 201;
  static const int response202Accepted = 202;
  static const int response203NonAuthoritativeInformation = 203;
  static const int response204NoContent = 204;
  static const int response205ResetContent = 205;
  static const int response206PartialContent = 206;
  static const int response207MultiStatus = 207;
  static const int response208AlreadyReported = 208;
  static const int response226ImUsed = 226;

  // Redirection
  static const int response300MultipleChoices = 300;
  static const int response301MovedPermanently = 301;
  static const int response302Found = 302;
  static const int response303SeeOther = 303;
  static const int response304NotModified = 304;
  static const int response305UseProxy = 305;
  static const int response306Reserved = 306;
  static const int response307TemporaryRedirect = 307;
  static const int response308PermanentRedirect = 308;

  // Client Error
  static const int response400BadResponse = 400;
  static const int response401Unauthorized = 401;
  static const int response402PaymentRequired = 402;
  static const int response403Forbidden = 403;
  static const int response404NotFound = 404;
  static const int response405MethodNotAllowed = 405;
  static const int response406NotAcceptable = 406;
  static const int response407ProxyAuthenticationRequired = 407;
  static const int response408ResponseTimeout = 408;
  static const int response409Conflict = 409;
  static const int response410Gone = 410;
  static const int response411LengthRequired = 411;
  static const int response412PreconditionFailed = 412;
  static const int response413ResponseEntityTooLarge = 413;
  static const int response414ResponseUriTooLong = 414;
  static const int response415UnsupportedMediaType = 415;
  static const int response416ResponseedRangeNotSatisfiable = 416;
  static const int response417ExpectationFailed = 417;
  static const int response421MisdirectedResponse = 421;
  static const int response422UnprocessableEntity = 422;
  static const int response423Locked = 423;
  static const int response424FailedDependency = 424;
  static const int response425TooEarly = 425;
  static const int response426UpgradeRequired = 426;
  static const int response428PreconditionRequired = 428;
  static const int response429TooManyResponses = 429;
  static const int response431ResponseHeaderFieldsTooLarge = 431;
  static const int response451UnavailableForLegalReasons = 451;

  // Server Error
  static const int response500InternalServerError = 500;
  static const int response501NotImplemented = 501;
  static const int response502BadGateway = 502;
  static const int response503ServiceUnavailable = 503;
  static const int response504GatewayTimeout = 504;
  static const int response505responseVersionNotSupported = 505;
  static const int response506VariantAlsoNegotiates = 506;
  static const int response507InsufficientStorage = 507;
  static const int response508LoopDetected = 508;
  static const int response509BandwidthLimitExceeded = 509;
  static const int response510NotExtended = 510;
  static const int response511NetworkAuthenticationRequired = 511;
}