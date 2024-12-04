;; Job Scheduler Contract

(define-map jobs
  { job-id: uint }
  {
    owner: principal,
    quantum-time: uint,
    priority: uint,
    status: (string-ascii 20)
  }
)

(define-data-var job-nonce uint u0)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-job (err u101))
(define-constant err-unauthorized (err u102))

(define-public (submit-job (quantum-time uint) (priority uint))
  (let
    (
      (job-id (+ (var-get job-nonce) u1))
    )
    (try! (contract-call? .quantum-time-token transfer quantum-time tx-sender (as-contract tx-sender)))
    (map-set jobs
      { job-id: job-id }
      {
        owner: tx-sender,
        quantum-time: quantum-time,
        priority: priority,
        status: "pending"
      }
    )
    (var-set job-nonce job-id)
    (ok job-id)
  )
)

(define-public (cancel-job (job-id uint))
  (let
    (
      (job (unwrap! (map-get? jobs { job-id: job-id }) err-invalid-job))
    )
    (asserts! (is-eq (get owner job) tx-sender) err-unauthorized)
    (asserts! (is-eq (get status job) "pending") err-invalid-job)
    (try! (as-contract (contract-call? .quantum-time-token transfer (get quantum-time job) tx-sender (get owner job))))
    (map-delete jobs { job-id: job-id })
    (ok true)
  )
)

(define-public (update-job-status (job-id uint) (new-status (string-ascii 20)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set jobs
      { job-id: job-id }
      (merge (unwrap! (map-get? jobs { job-id: job-id }) err-invalid-job)
             { status: new-status })
    )
    (ok true)
  )
)

(define-read-only (get-job (job-id uint))
  (map-get? jobs { job-id: job-id })
)

