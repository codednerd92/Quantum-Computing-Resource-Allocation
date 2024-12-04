;; Quantum Marketplace Contract

(define-map listings
  { listing-id: uint }
  {
    seller: principal,
    quantum-time: uint,
    price: uint,
    status: (string-ascii 20)
  }
)

(define-data-var listing-nonce uint u0)

(define-constant err-invalid-listing (err u100))
(define-constant err-unauthorized (err u101))
(define-constant err-invalid-status (err u102))

(define-public (create-listing (quantum-time uint) (price uint))
  (let
    (
      (listing-id (+ (var-get listing-nonce) u1))
    )
    (try! (contract-call? .quantum-time-token transfer quantum-time tx-sender (as-contract tx-sender)))
    (map-set listings
      { listing-id: listing-id }
      {
        seller: tx-sender,
        quantum-time: quantum-time,
        price: price,
        status: "active"
      }
    )
    (var-set listing-nonce listing-id)
    (ok listing-id)
  )
)

(define-public (cancel-listing (listing-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings { listing-id: listing-id }) err-invalid-listing))
    )
    (asserts! (is-eq (get seller listing) tx-sender) err-unauthorized)
    (asserts! (is-eq (get status listing) "active") err-invalid-status)
    (try! (as-contract (contract-call? .quantum-time-token transfer (get quantum-time listing) tx-sender (get seller listing))))
    (map-delete listings { listing-id: listing-id })
    (ok true)
  )
)

(define-public (buy-listing (listing-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings { listing-id: listing-id }) err-invalid-listing))
    )
    (asserts! (is-eq (get status listing) "active") err-invalid-status)
    (try! (stx-transfer? (get price listing) tx-sender (get seller listing)))
    (try! (as-contract (contract-call? .quantum-time-token transfer (get quantum-time listing) tx-sender tx-sender)))
    (map-delete listings { listing-id: listing-id })
    (ok true)
  )
)

(define-read-only (get-listing (listing-id uint))
  (map-get? listings { listing-id: listing-id })
)

