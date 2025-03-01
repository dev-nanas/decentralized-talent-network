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
