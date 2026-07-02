# Bucket tempat Nexus menyimpan komponen (blob store)
resource "google_storage_bucket" "nexus_blobstore" {
  name     = var.gcs_bucket_name
  location = var.gcp_region1

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }
  force_destroy = false
}

# GCP Service Account yang akan "dipinjam" oleh Pod Nexus lewat
# Workload Identity — tidak ada JSON key yang perlu dibuat/di-download.
resource "google_service_account" "nexus_gcs" {
  account_id   = "nexus-gcs"
  display_name = "Nexus GCS Blobstore"
}

# Beri akses baca/tulis objek ke bucket, dibatasi ke bucket ini saja
# (bukan roles/storage.admin project-wide).
resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.nexus_blobstore.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.nexus_gcs.email}"
}

resource "google_storage_bucket_iam_member" "storage_admin" {
  bucket = google_storage_bucket.nexus_blobstore.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.nexus_gcs.email}"
}

resource "google_project_iam_member" "datastore" {
  project = var.gcp_project
  role = "roles/datastore.owner"
  member = "serviceAccount:${google_service_account.nexus_gcs.email}"
}

resource "google_project_iam_member" "datastore_user" {
  project = var.gcp_project
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.nexus_gcs.email}"
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.nexus_gcs.name
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.gcp_project}.svc.id.goog[nexus/nexus]"
}
