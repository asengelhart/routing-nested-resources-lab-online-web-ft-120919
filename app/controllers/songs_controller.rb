class SongsController < ApplicationController
  def index
    if params[:artist_id]
      artist = Artist.includes(:songs).find_by(id: params[:artist_id])
      if artist.nil?
        flash[:alert] = "Artist not found"
        redirect_to artists_path
      else
        @songs = artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    # Ideally, I would prefer to redirect to the songs index when any invalid song id is
    # passed, but that's not what the spec calls for here

    @song = Song.find_by(id: params[:id])
    artist = params[:artist_id] ? Artist.find_by(id: params[:artist_id]) : nil
    if artist.nil?
      if @song.nil?
        flash[:alert] = "Song not found."
        redirect_to songs_path
      end
    else
      if @song.nil? || artist.songs.include?(@song) == false
        flash[:alert] = "Song not found."
        redirect_to artist_songs_path(artist.id)
      end
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

