require "net/http"
require "uri"

class AlbumsController < ApplicationController
  before_action :set_album, only: %i[show edit update destroy]
  before_action :fetch_artists_from_api, only: %i[new edit]
  before_action :verify_admin, only: [ :destroy ]




  def verify_admin
    unless current_user&.admin?
      redirect_to albums_path, alert: "Você não tem permissão para deletar álbuns."
    end
  end



  def index
    @albums = Album.all
    @artists_hash = build_artists_hash
  end


  def show
    @artists_hash = build_artists_hash
    @artist_name = @artists_hash[@album.artist_id] || "Unknown Artist"
  end


  def new
    @album = Album.new
    fetch_artists_from_api
  end



  def edit
  end


  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        fetch_artists_from_api
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        fetch_artists_from_api
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private


  def set_album
    @album = Album.find(params[:id])
  end


  def fetch_artist_name_from_api(artist_id)
    return "Unknown Artist" if artist_id.nil?

    url = URI("https://europe-west1-madesimplegroup-151616.cloudfunctions.net/artists-api-controller?artist_id=#{artist_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Basic ZGV2ZWxvcGVyOlpHVjJaV3h2Y0dWeQ=="
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      artist_data = JSON.parse(response.body)
      artist_data["name"] || "Unknown Artist"
    else
      "Unknown Artist"
    end
  end


  def build_artists_hash
    url = URI("https://europe-west1-madesimplegroup-151616.cloudfunctions.net/artists-api-controller")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Basic ZGV2ZWxvcGVyOlpHVjJaV3h2Y0dWeQ=="
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      artists = JSON.parse(response.body)["json"].flatten
      artists.each_with_object({}) do |artist, hash|
        hash[artist["id"]] = artist["name"]
      end
    else
      {}
    end
  end


  def fetch_artists_from_api
    @artists_collection = build_artists_hash.map { |id, name| [ name, id ] }
  end


  def album_params
    params.require(:album).permit(:name, :artist_id, :year)
  end
end
