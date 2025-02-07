FROM archlinux:base-devel

# Enter shell on start
ENTRYPOINT ["/bin/zsh"]

# Add my user
RUN useradd -m dev

# Install packages
RUN pacman -Syu --noconfirm && \
    # Basic packages
    pacman -S zsh openssh keychain git neovim --noconfirm && \
    # Dependencies
    pacman -S go npm unzip chezmoi --noconfirm && \
    # Nice to haves
    pacman -S fzf tree bat exa kubectl git-delta --noconfirm

# Prepare git
RUN ssh-keyscan github.com >> /etc/ssh/known_hosts

# Change to user
USER dev
WORKDIR /home/dev

# Hack to get zsh to work due to dependency
RUN echo "" >> ~/.aliases.secret

# Prepare folders
RUN \
    mkdir -p ~/.config && \
    mkdir -p ~/.local/{src,share}

# Install oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN chezmoi init --apply deifyed

# Fetch necessary and distribute dotfiles
#RUN git clone https://github.com/rupa/z.git ~/.local/src/z

# Init vim
RUN nvim --headless '+Lazy install' +MasonUpdate +qall
