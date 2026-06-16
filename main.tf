/* resource "google_compute_instance" "vm"{
    name            ="tf-demo-vm"
    machine_type    ="e2-micro"
    zone            =var.zone

    boot_disk{
        initialize_params {
            image   = "debian-cloud/debian-12"
        }

    }

    network_interface {
        network     = "default"

        access_config {}

    }

    tags            = ["terraform-demo"]


} */

resource "google_project_service" "pubsub" {

    project         = var.project_id
    service         = "pubsub.googleapis.com"

    disable_on_destroy  = false
}

resource "google_project_service" "firestore" {

    project         = var.project_id 
    service         = "firestore.googleapis.com"

    disable_on_destroy = false
}

resource "google_pubsub_topic" "topic" {

    name = "demo-topic"

    depends_on = [google_project_service.pubsub]
}

resource "google_pubsub_subscription" "subscription" {

    name    ="demo-subscription"
    topic   =google_pubsub_topic.topic.name

    ack_deadline_seconds = 20

    depends_on = [google_project_service.pubsub]
}

resource "google_firestore_database" "default" {
    project     = var.project_id
    name        = "(default)"
    location_id = "us-central1"

    type = "FIRESTORE_NATIVE"

    depends_on = [google_project_service.firestore]

}