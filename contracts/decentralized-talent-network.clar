;; Professional Talent Connection Platform
;; A decentralized system for connecting talent with opportunities
;; This smart contract enables talent registration, business registration,
;; and opportunity posting with secure profile management.

;; ======== DATA STRUCTURES ========

;; Storage for professional talent profiles
(define-map talent-profiles
    principal
    {
        full-name: (string-ascii 100),
        expertise: (list 10 (string-ascii 50)),
        geo-area: (string-ascii 100),
        background: (string-ascii 500)
    }
)

;; Storage for business entities
(define-map business-entities
    principal
    {
        org-name: (string-ascii 100),
        sector: (string-ascii 50),
        geo-area: (string-ascii 100)
    }
)

;; Storage for opportunity postings
(define-map opportunity-posts
    principal
    {
        position: (string-ascii 100),
        details: (string-ascii 500),
        poster: principal,
        geo-area: (string-ascii 100),
        qualifications: (list 10 (string-ascii 50))
    }
)

;; ======== ERROR DEFINITIONS ========

(define-constant ERROR-RESOURCE-MISSING (err u404))
(define-constant ERROR-DUPLICATE-ENTRY (err u409))
(define-constant ERROR-INVALID-EXPERTISE (err u400))
(define-constant ERROR-INVALID-AREA (err u401))
(define-constant ERROR-INVALID-BACKGROUND (err u402))
(define-constant ERROR-INVALID-OPPORTUNITY (err u403))
(define-constant ERROR-ENTITY-NOT-FOUND (err u404))

;; ======== READ-ONLY FUNCTIONS ========

;; Retrieve talent profile information
(define-read-only (fetch-talent-data (account-id principal))
    (match (map-get? talent-profiles account-id)
        data (ok data)
        ERROR-RESOURCE-MISSING
    )
)

;; Retrieve business entity information
(define-read-only (fetch-business-data (account-id principal))
    (match (map-get? business-entities account-id)
        data (ok data)
        ERROR-RESOURCE-MISSING
    )
)

;; Retrieve opportunity posting details
(define-read-only (fetch-opportunity-data (post-id principal))
    (match (map-get? opportunity-posts post-id)
        data (ok data)
        ERROR-RESOURCE-MISSING
    )
)

;; ======== PUBLIC FUNCTIONS ========

;; Create a new business entity profile
(define-public (create-business-profile 
    (org-name (string-ascii 100))
    (sector (string-ascii 50))
    (geo-area (string-ascii 100)))
    (let
        (
            (account-owner tx-sender)
            (existing-record (map-get? business-entities account-owner))
        )
        ;; Check if profile already exists
        (if (is-none existing-record)
            (begin
                ;; Validate all required fields
                (if (or (is-eq org-name "")
                        (is-eq sector "")
                        (is-eq geo-area ""))
                    (err ERROR-INVALID-AREA)
                    (begin
                        ;; Record the new business profile
                        (map-set business-entities account-owner
                            {
                                org-name: org-name,
                                sector: sector,
                                geo-area: geo-area
                            }
                        )
                        (ok "Business profile successfully created.")
                    )
                )
            )
            (err ERROR-DUPLICATE-ENTRY)
        )
    )
)

;; Post a new opportunity listing
(define-public (post-opportunity 
    (position (string-ascii 100))
    (details (string-ascii 500))
    (geo-area (string-ascii 100))
    (qualifications (list 10 (string-ascii 50))))
    (let
        (
            (account-owner tx-sender)
            (existing-post (map-get? opportunity-posts account-owner))
        )
        ;; Verify posting doesn't already exist
        (if (is-none existing-post)
            (begin
                ;; Ensure all required fields are valid
                (if (or (is-eq position "")
                        (is-eq details "")
                        (is-eq geo-area "")
                        (is-eq (len qualifications) u0))
                    (err ERROR-INVALID-OPPORTUNITY)
                    (begin
                        ;; Store the opportunity posting
                        (map-set opportunity-posts account-owner
                            {
                                position: position,
                                details: details,
                                poster: account-owner,
                                geo-area: geo-area,
                                qualifications: qualifications
                            }
                        )
                        (ok "Opportunity successfully posted.")
                    )
                )
            )
            (err ERROR-DUPLICATE-ENTRY)
        )
    )
)

;; Create a talent profile
(define-public (create-talent-profile 
    (full-name (string-ascii 100))
    (expertise (list 10 (string-ascii 50)))
    (geo-area (string-ascii 100))
    (background (string-ascii 500)))
    (let
        (
            (account-owner tx-sender)
            (existing-record (map-get? talent-profiles account-owner))
        )
        ;; Check if profile already exists
        (if (is-none existing-record)
            (begin
                ;; Validate all required information
                (if (or (is-eq full-name "")
                        (is-eq geo-area "")
                        (is-eq (len expertise) u0)
                        (is-eq background ""))
                    (err ERROR-INVALID-BACKGROUND)
                    (begin
                        ;; Record the new talent profile
                        (map-set talent-profiles account-owner
                            {
                                full-name: full-name,
                                expertise: expertise,
                                geo-area: geo-area,
                                background: background
                            }
                        )
                        (ok "Talent profile successfully created.")
                    )
                )
            )
            (err ERROR-DUPLICATE-ENTRY)
        )
    )
)

