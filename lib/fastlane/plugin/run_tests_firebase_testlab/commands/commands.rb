module Fastlane
  module Commands
    def self.config
      "gcloud config set project"
    end

    def self.auth
      "gcloud auth activate-service-account"
    end

    def self.run_tests
      "gcloud firebase test android run"
    end

    def self.download_results
      "gsutil -m cp -r"
    end

    def self.download_single_file
      "gsutil -m cp"
    end

    def self.list_object
      "gsutil ls"
    end

    def self.delete_resuls
      "gsutil rm -r"
    end
  end
end
