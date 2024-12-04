;; Performance Tracker Contract

(define-map algorithm-performance
  { algorithm-id: (string-ascii 64) }
  {
    total-runs: uint,
    total-time: uint,
    average-time: uint,
    last-run-time: uint
  }
)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))

(define-public (record-performance (algorithm-id (string-ascii 64)) (run-time uint))
  (let
    (
      (current-performance (default-to
        { total-runs: u0, total-time: u0, average-time: u0, last-run-time: u0 }
        (map-get? algorithm-performance { algorithm-id: algorithm-id })))
      (new-total-runs (+ (get total-runs current-performance) u1))
      (new-total-time (+ (get total-time current-performance) run-time))
      (new-average-time (/ new-total-time new-total-runs))
    )
    (map-set algorithm-performance
      { algorithm-id: algorithm-id }
      {
        total-runs: new-total-runs,
        total-time: new-total-time,
        average-time: new-average-time,
        last-run-time: run-time
      }
    )
    (ok true)
  )
)

(define-read-only (get-algorithm-performance (algorithm-id (string-ascii 64)))
  (map-get? algorithm-performance { algorithm-id: algorithm-id })
)

